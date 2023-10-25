% written by l.hao (ver_18.09.08)
% rock3.hao@gmail.com
% qinlab.BNU
% modified for BART by Shamrockheart (19.10.23)
restoredefaultpath
clear

%% Set up
% resubmask  = 1;
img_type  = 'spmT';  % 'spmT' or 'con'
task_name = 'BART';
cond_name  = {'Decision';'Reward';'Risk'};
rsa_file  =  {
    '/brain/iCAN_admin/home/JiangMin/Neo_BART_2019/Neo_Scripts/Neo_RSA/RSA_Templates/fDecision_spmT_0001_FDR005_C30.nii';
    '/brain/iCAN_admin/home/JiangMin/Neo_BART_2019/Neo_Scripts/Neo_RSA/RSA_Templates/fReward_spmT_0001_FDR005_C30.nii';
    '/brain/iCAN_admin/home/JiangMin/Neo_BART_2019/Neo_Scripts/Neo_RSA/RSA_Templates/fRisk_spmT_0001_FDR005_C30.nii';
    };
spm_dir  = '/brain/iCAN_admin/home/JiangMin/Toolbox/spm12';
roi_dir  = '/brain/iCAN_admin/home/JiangMin/Neo_BART_2019/Neo_Scripts/Neo_RSA/RSA_Masks';
firlv_dir  = '/brain/iCAN_admin/home/JiangMin/Results/First_Level';
subjlist  = '/brain/iCAN_admin/home/JiangMin/Neo_BART_2019/Neo_Database/BART_list/Children_list.txt';

%% RSA correlation
% Read subject list
fid = fopen(subjlist); sublist = {}; cnt_list = 1;
while ~feof(fid)
    linedata = textscan(fgetl(fid), '%s', 'Delimiter', '\t');
    sublist(cnt_list,:) = linedata{1}; cnt_list = cnt_list + 1; %#ok<*SAGROW>
end
fclose(fid);

% Acquire ROI file & list
roi_list = dir(fullfile(roi_dir,'*.nii'));
roi_list = struct2cell(roi_list);
roi_list = roi_list(1,:)';

% Add path
addpath(genpath (spm_dir));

allres = {'Scan_ID'};
for con_i = 1:length(cond_name)
    
    for roi_i = 1:length(roi_list)
        allres{1,roi_i+1} = roi_list{roi_i,1}(1:end-4);
        roifile = fullfile(roi_dir, roi_list{roi_i,1});
        
        mask  = spm_read_vols(spm_vol(roifile));
        rsa_img  = spm_read_vols(spm_vol(rsa_file{con_i,1}));
        rsa_vect = rsa_img(mask(:)==1);
        
        rsa_vect(isnan(rsa_vect)) = nanmean(rsa_vect);%%
        
        for sub_i = 1:length(sublist)
            allres{sub_i+1,1} = sublist{sub_i,1};
            
            yearID  = ['20',sublist{sub_i,1}(1:2)];
            sub_file = fullfile(firlv_dir, yearID, sublist{sub_i,1},...
                ['fmri/stats_spm8/', task_name, '/stats_spm8_swcar'], ...
                [img_type,'_000',num2str(con_i),'.nii']);
            
            sub_img = spm_read_vols(spm_vol(sub_file));
%             if resubmask == 1
%                 sub_vect_nan = sub_img(mask(:)==1);
%                 rsa_vect = rsa_vect(~isnan(sub_vect_nan));
%                 
%                 submaskfile = fullfile(firlv_dir, yearID, sublist{sub_i,1},...
%                      ['fmri/stats_spm8/', task_name, '/stats_spm8_swcar'], ...
%                      'mask.nii');
%                 submask = spm_read_vols(spm_vol(submaskfile));
%                 mask = submask & mask;
%             end
            
            sub_vect = sub_img(mask(:)==1);
            
            sub_vect(isnan(sub_vect)) = nanmean(sub_vect);%%
            
            [rsa_r, rsa_p] = corr(rsa_vect, sub_vect);
%             allres{sub_i+1,roi_i+1} = rsa_r;
            allres{sub_i+1,roi_i+1} = 0.5*log((1+rsa_r)/(1-rsa_r));
        end
    end
    % Save Results
    save_name = ['Neo_RSA_1028_', cond_name{con_i,1}, '_', img_type,'.csv'];
    
    fid = fopen(save_name, 'w');
    [nrows,ncols] = size(allres);
    col_num = '%s';
    for col_i = 1:(ncols-1); col_num = [col_num,',','%s']; end %#ok<*AGROW>
    col_num = [col_num, '\n'];
    for row_i = 1:nrows; fprintf(fid, col_num, allres{row_i,:}); end;
    fclose(fid);
end

%% done
disp('>>> RSA calculate done <<<');