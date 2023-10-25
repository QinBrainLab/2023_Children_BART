%Written for BART Analyses
%Presented by Shamrockheart
%Modified on October 9, 2018
%TST Ace Module on February 11, 2020

close all; clear all; clc
disp('>>>>>>>>>>Start<<<<<<<<<<')

database_name={'Adults','Children'};
condition={'pump','cashout','explode'};
mask_index={'Control','Approach','Avoidance'};
num={'1','2','3'};
value_path='/brain/iCAN_admin/home/JiangMin/Neo_BART_2019/Neo_Results/TST_Ace_Module_Value_Activation';
if ~exist(value_path, 'dir')
    mkdir(value_path)
end
for u=1:2
    load(strcat('/brain/iCAN_admin/home/JiangMin/Neo_BART_2019/Neo_Database/BART_Database_',database_name{1,u},'.mat'))
    database=eval(database_name{1,u});
    database_path=strcat(value_path,'/',database_name{1,u});
    if ~exist(database_path, 'dir')
        mkdir(database_path)
    end
    for v=1:3
        condition_path=strcat(database_path,'/',condition{1,v});
        if ~exist(condition_path, 'dir')
            mkdir(condition_path)
        end
        for i=1:length(database(:,1))
             year=regexp(database{i,2},'1\w+','match','once');
             out_f=strcat('/brain/iCAN_admin/home/JiangMin/Results/First_Level/20',year,'/',database{i,2});    
             cd(out_f);
             run=strcat(out_f,'/fmri/stats_spm8/BART/stats_spm8_swcar/spmT_000',num{1,v},'.nii');
             vol_run=spm_vol(run);
             array_run=spm_read_vols(vol_run);
             for j=1:length(mask_index)
                mask=strcat('/brain/iCAN_admin/home/JiangMin/Neo_BART_2019/Neo_ROIs/TST_Ace_Module_ROI/TST_',mask_index{1,j},'.nii');  
                vol_mask=spm_vol(mask);
                array_mask=spm_read_vols(vol_mask);
                temp=array_run(find(array_mask(:)==1));
                data_mean(i,j)=nanmean(temp);
             end
        end
        cd(condition_path)
        save TST_Ace_Module_Value_Activation.mat data_mean
    end
end

disp('>>>>>>>>>>Completed<<<<<<<<<<')