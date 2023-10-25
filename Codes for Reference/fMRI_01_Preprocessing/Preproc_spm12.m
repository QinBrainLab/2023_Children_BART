% Written by Hao (17/07/12)
% QinLab, BNU
% haolpsy@gmail.com
clear
restoredefaultpath

%% ------------------------------ Set Up ------------------------------- %%
% Set Path
SPM_Dir     = '/Users/hao1ei/Toolbox/spm12';
Scripts_Dir = '/Users/hao1ei/MyProjects/Scripts/Preprocess/Preproc_spm12';
Preproc_Dir = '/Users/hao1ei/Downloads/ScriptsTest/Preproc/Preproc_SPM12/data';
SubList     = fullfile(Scripts_Dir,'SubList_ANT1_YesExist_Hao2.txt');

% Set Basic Information
fmriName   = {'ANT1'}; % if multi run, use: {'Run1';'Run2'}
TR         = 2;
T1Filter   = 'I';
FuncFilter = 'I';
DataType   = 'nii';
SliceOrder = [1:2:33 2:2:32];

% Function Switch
PreprocYN   = 1;
MoveExcluYN = 1;

%% The following do not need to be modified
%% Import SubList
fid      = fopen(SubList);
ID_List  = {};
Cnt_List = 1;
while ~feof(fid)
    linedata = textscan(fgetl(fid), '%s', 'Delimiter', '\t');
    ID_List(Cnt_List,:) = linedata{1}; %#ok<*SAGROW>
    Cnt_List = Cnt_List + 1;
end
fclose(fid);
%% Addpath
addpath (genpath (SPM_Dir));
addpath (genpath (Scripts_Dir));

%% -------------------------- Preprocess fmri -------------------------- %%
% SliceTiming = 'a > ar'; Realign = 'r > c'; Normalise = 'w'; Smooth = 's'.
if PreprocYN ==1
    for i = 1:length(ID_List)
        for run = 1:length(fmriName)
            YearID = ['20',ID_List{i,1}(1:2)];
            SubjDir = ID_List{i};
            disp ([SubjDir,' Preprocess Started'])
            
            T1Dir     = fullfile(Preproc_Dir,YearID,SubjDir,'/mri/anatomy/');
            FuncDir   = fullfile(Preproc_Dir,YearID,SubjDir,'/fmri/',fmriName{run,1},'/unnormalized/');
            FinalDir = fullfile(Preproc_Dir,YearID,SubjDir,'/fmri/',fmriName{run,1},'/smoothed_spm12/');
            
            cd (FuncDir)
            Step1_Script (FuncDir,FuncFilter,T1Dir,T1Filter,SliceOrder,TR,DataType);
            Step2_Script (FuncDir,FuncFilter,T1Dir,T1Filter,SliceOrder,TR,DataType);
            
            unix (sprintf ('gzip meanarI.nii'));
            unix (sprintf ('gzip wcarI.nii'));
            unix (sprintf ('gzip swcarI.nii'));
            unix (sprintf ('gzip I.nii'));
            unix (sprintf ('gzip I_all.nii'));
            
            unix (sprintf ('rm arI.mat'));
            unix (sprintf ('rm arI.nii'));
            unix (sprintf ('rm c*meanarI.nii'));
            unix (sprintf ('rm carI.nii'));
            unix (sprintf ('rm meanarI_seg8.mat'));
            
            rpFile      = fullfile(FuncDir,'rp_arI.txt');
            MeanFile    = fullfile(FuncDir,'meanarI.nii.gz');
            VlmRep_GS   = fullfile(FuncDir,'VolumRepair_GlobalSignal.txt');
            SmoothFile  = fullfile(FuncDir,'swcarI.nii.gz');
            NoSmoothFile  = fullfile(FuncDir,'wcarI.nii.gz');
            
            mkdir (FinalDir)
            movefile(rpFile,FinalDir)
            movefile(MeanFile,FinalDir)
            movefile(VlmRep_GS,FinalDir)
            movefile(SmoothFile,FinalDir)
            movefile(NoSmoothFile,FinalDir)
            
            cd (T1Dir)
            unix (sprintf ('rm I_seg8.mat'));
            unix (sprintf ('rm y_I.nii'));
            unix (sprintf ('gzip I.nii'));
        end
    end
end
cd (Scripts_Dir)

%% ------------------------- Movement Exclusion ------------------------ %%
if MoveExcluYN ==1
    for k = 1:length(fmriName)
        mConfigName = ['Config_MoveExclu_',fmriName{k,1},'.m'];
        mConfig = fopen (mConfigName,'a');
        fprintf (mConfig,'%s\n',['paralist.ServerPath = ''',Preproc_Dir,''';']);
        fprintf (mConfig,'%s\n','paralist.PreprocessedFolder = ''smoothed_spm12'';');
        
        fprintf (mConfig,'%s\n',['fid = fopen(''',SubList,''');']);
        fprintf (mConfig,'%s\n','ID_List = {};');
        fprintf (mConfig,'%s\n','Cnt_List = 1;');
        fprintf (mConfig,'%s\n','while ~feof(fid)');
        fprintf (mConfig,'%s\n','linedata = textscan(fgetl(fid), ''%s'', ''Delimiter'', ''\t'');');
        fprintf (mConfig,'%s\n','ID_List(Cnt_List,:) = linedata{1};');
        fprintf (mConfig,'%s\n','Cnt_List = Cnt_List + 1;');
        fprintf (mConfig,'%s\n','end');
        fprintf (mConfig,'%s\n','fclose(fid);');
        
        fprintf (mConfig,'%s\n','paralist.SubjectList = ID_List;');
        fprintf (mConfig,'%s\n',['paralist.SessionList = {''',fmriName{k,1},'''};']);
        fprintf (mConfig,'%s\n','paralist.ScanToScanCrit = 0.5;');
        
        MoveExclu_spm12_Hao(mConfigName)
    end
    
    if ~exist('Res_Log','dir')
        mkdir (fullfile(Scripts_Dir,'Res_Log'))
    end
    movefile ('Log_Movement*.txt','Res_Log')
    movefile ('Config_MoveExclu*.m','Res_Log')
end

%% All Done
clear
disp ('All Done');