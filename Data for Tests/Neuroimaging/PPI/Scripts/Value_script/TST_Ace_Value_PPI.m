%Written for BART Analyses
%Presented by JM
%Modified on December 19, 2019
%TST Ace on February 17, 2020

close all; clear all; clc
disp('>>>>>>>>Start<<<<<<<<')

database_name={'Adults','Children'};
condition={'pump','cashout','explode'};
seed_index={'dACC','DLPFC','VMPFC','NAc','Caudate','Putamen','Amygdala','Insula','Hippocampus'};
mask_index=seed_index;
value_path='/brain/iCAN_admin/home/JiangMin/Neo_BART_2019/Neo_Results/Ace_Value_PPI';
if ~exist(value_path, 'dir')
    mkdir(value_path)
end
for u=1:2
    load(strcat('/brain/iCAN_admin/home/JiangMin/Neo_BART_2019/Neo_Database/BART_Database_',database_name{1,u},'.mat'))
    database=eval(database_name{1,u});
    database_path=strcat(value_path,'/',database_name{1,u});
    mkdir(database_path)
    for v=1:3
        condition_path=strcat(database_path,'/',condition{1,v});
        mkdir(condition_path)
        for i=1:length(database(:,1))
             year=regexp(database{i,2},'1\w+','match','once');
             out_f=strcat('/brain/iCAN_admin/home/JiangMin/Results/First_Level/20',year,'/',database{i,2});    
             cd(out_f);
             for j=1:length(seed_index)
                run=strcat(out_f,'/fmri/stats_spm8/BART/stats_spm8_swcar_gPPI_Ace_2020/PPI_TST_',seed_index{1,j},'/spmT_PPI_',condition{1,v},'_',database{i,2},'.img');
                vol_run=spm_vol(run);
                array_run=spm_read_vols(vol_run);
                for k=1:length(mask_index)
                    mask=strcat('/brain/iCAN_admin/home/JiangMin/Neo_BART_2019/Neo_ROIs/TST_Ace_ROI/TST_',mask_index{1,k},'.nii');
                    vol_mask=spm_vol(mask);
                    array_mask=spm_read_vols(vol_mask);
                    temp=array_run(find(array_mask(:)==1));
                    data_mean(k,j,i)=mean(temp);
                end
             end
        end
        cd(condition_path)
        save Ace_Value_PPI.mat data_mean
    end
end

disp('>>>>>>>>Completed<<<<<<<<')