% Written by Hao (17/07/12)
% QinLab, BNU
% haolpsy@gmail.com
clear
restoredefaultpath

%% ------------------------------ Set Up ------------------------------- %%
% Basic Configure
YourName    = 'Hao';
Dcm2niiTool = 'dcm2niix';
ScriptDir   = '/Users/hao1ei/MyProjects/Scripts/Preprocess/Preproc_spm12/Preproc';
RawImgDir   = '/Users/hao1ei/Downloads/ScriptsTest/Preproc/Preproc_SPM12/Rawdata';
ArrImgDir   = '/Users/hao1ei/Downloads/ScriptsTest/Preproc/Preproc_SPM12/data';
RawList     = fullfile(ScriptDir,'SubList_Raw.txt');
ImgList     = fullfile(ScriptDir,'SubList_Img.txt');

fmriName    = {'ANT1';'ANT2'};
fmriKeyword = {'ANT1';'ANT2'};
TimeDel     = {'4';'4'};
TimeRemain  = {'173';'173'};
mriName     = {'anatomy'};
mriKeyword  = {'Crop'}; 

% Function Switch
ImgConvert     = 1; % 0=Skip  1=Run
MultiImgChoose = 0; % 0=Skip  1=Choose last image
TimePointDel   = 1; % 0=Skip  1=Run
SubRename      = 1; % 0=Skip  1=Run

%% ---------------------------- Read Lists ----------------------------- %%
fid      = fopen(RawList);
SubName  = {};
Cnt_List = 1;
while ~feof(fid)
    linedata = textscan(fgetl(fid), '%s', 'Delimiter', '\t');
    SubName(Cnt_List,:) = linedata{1}; %#ok<*SAGROW>
    Cnt_List = Cnt_List + 1;
end
fclose(fid);

fid        = fopen(ImgList);
SubNewName = {};
Cnt_List   = 1;
while ~feof(fid)
    linedata = textscan(fgetl(fid), '%s', 'Delimiter', '\t');
    SubNewName(Cnt_List,:) = linedata{1}; %#ok<*SAGROW>
    Cnt_List = Cnt_List + 1;
end
fclose(fid);

%% ----------------------------- Img Convert --------------------------- %%
if ImgConvert == 1
    for i = 1:length(SubName)
        YearID = ['20',SubNewName{i,1}(1:2)];
        SubImgDir = fullfile(RawImgDir,SubName{i,1});
        OutImgDir = fullfile(ArrImgDir,YearID,'Cache',SubName{i,1});
        mkdir (OutImgDir);
        if strcmp(Dcm2niiTool,'dcm2niix') == 1
            unix(sprintf([Dcm2niiTool,' -x y -z n -o ',OutImgDir,' ',SubImgDir,'/*']));
        elseif strcmp(Dcm2niiTool,'dcm2nii') == 1
            unix(sprintf([Dcm2niiTool,' -g n -o ',OutImgDir,' ',SubImgDir,'/*']));
        end
        
        % Arrange mri
        for j = 1:length(mriName)
            mriDir = fullfile(ArrImgDir,YearID,SubName{i,1},'mri',mriName{j,1});
            mkdir (mriDir);
            TempmriName = dir([OutImgDir,'/*',mriKeyword{j,1},'*']);
            if isempty(TempmriName)
                unix(['echo ',SubNewName{i,1},' >> ',ScriptDir,'/SubList_',mriName{j,1},'_NoExist_',YourName,'.txt']);
            elseif length(TempmriName) == 1
                unix(['mv ',[OutImgDir,'/',TempmriName(1,1).name],' ',mriDir,'/I.nii']);
                unix(['echo ',SubNewName{i,1},' >> ',ScriptDir,'/SubList_',mriName{j,1},'_YesExist_',YourName,'.txt']);
            elseif length(TempmriName) >= 2
                unix(['echo ',SubNewName{i,1},' >> ',ScriptDir,'/SubList_',mriName{j,1},'_MoreThan2_',YourName,'.txt']);
                if MultiImgChoose == 1
                    unix(['mv ',[OutImgDir,'/',TempmriName(length(TempmriName),1).name],' ',mriDir,'/I.nii']);
                end
            end
        end
        
        % Arrange fmri
        for j = 1:length(fmriName)
            fmriDir = fullfile(ArrImgDir,YearID,SubName{i,1},'fmri',fmriName{j,1},'unnormalized');
            % TaskDesignDir=fullfile(ArrImgDir,YearID,SubName{i,1},'fmri',fmriName{j,1},'Task_Design');
            mkdir (fmriDir);
            % mkdir (TaskDesignDir);
            TempfmriName = dir ([OutImgDir,'/*',fmriKeyword{j,1},'*']);
            mriDir = fullfile (ArrImgDir,YearID,SubName{i,1},'mri',mriName{1,1});
            if isempty(TempfmriName)
                unix (['echo ',SubNewName{i,1},' >> ',ScriptDir,'/SubList_',fmriName{j,1},'_NoExist_',YourName,'.txt']);
            elseif length(TempfmriName) == 1
                unix (['mv ',[OutImgDir,'/',TempfmriName(1,1).name],' ',fmriDir,'/I.nii']);
                mriYN = exist([mriDir,'/I.nii'],'file');
                if mriYN == 2
                    unix(['echo ',SubNewName{i,1},' >> ',ScriptDir,'/SubList_',fmriName{j,1},'_YesExist_',YourName,'.txt']);
                end
            elseif length(TempfmriName) >= 2
                unix (['echo ',SubNewName{i,1},' >> ',ScriptDir,'/SubList_',fmriName{j,1},'_MoreThan2_',YourName,'.txt']);
                if MultiImgChoose == 1
                    unix (['mv ',[OutImgDir,'/',TempfmriName(length(TempfmriName),1).name],' ',fmriDir,'/I.nii']);
                end
            end
        end
    end
end

%% ---------------------------- TimePoint Del -------------------------- %%
if TimePointDel == 1
    for i = 1:length(SubName)
        YearID = ['20',SubNewName{i,1}(1:2)];
        for j = 1:length(fmriName)
            fmriDir=fullfile (ArrImgDir,YearID,SubName{i,1},'fmri',fmriName{j,1},'unnormalized');
            fmriYN = exist ([fmriDir,'/I.nii'],'file');
            if fmriYN == 0
                disp ([SubNewName{i,1},' ',fmriName{j,1},' No_Exist']);
            elseif fmriYN == 2
                unix (['mv ',[fmriDir,'/I.nii'],' ',fmriDir,'/I_all.nii']);
                unix (['fslroi ',fmriDir,'/I_all.nii ',fmriDir,'/I.nii ',TimeDel{j,1},' ',TimeRemain{j,1}]);
                unix (['gunzip ',fmriDir,'/I.nii.gz']);
            end
        end
    end
end

%% --------------------------- Subject Rename -------------------------- %%
if SubRename == 1
    for i = 1:length(SubName)
        YearID = ['20',SubNewName{i,1}(1:2)];
        SubYN = exist (fullfile(ArrImgDir,YearID,SubName{i,1}),'file');
        if SubYN == 0
            disp ([SubNewName{i,1},' No_Exist']);
        elseif SubYN == 7
            unix (['mv ',ArrImgDir,'/',YearID,'/',SubName{i,1},' ',ArrImgDir,'/',YearID,'/',SubNewName{i,1}]);
        end
    end
end

%% All Done
clear
disp ('All Done');