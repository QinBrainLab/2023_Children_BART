%Written for BART Analyses (2020/01/07)
%Presented by Shamrockheart
%TST Ace on February 17, 2020

close all; clear all; clc
disp('>>>>>>>>>>Start<<<<<<<<<<')

root_path='D:\JM_Neo_BART\TST_Ace_Analyses\PPI\Results\Ace_Value_PPI\xls';
condition={'pump','cashout','explode'};
con=[];
seed_ROI={'dACC','DLPFC','VMPFC','NAc','Caudate','Putamen','Amygdala','Insula','Hippocampus'};
mask_ROI=seed_ROI;
for x=1:9
    for y=1:9
        label{1,y}=strcat(seed_ROI{1,x},'_',mask_ROI{1,y});
    end
    con=[con,label];
end
attributes=['Group',con(1,1:80)];

for i=1:3
    a=xlsread(strcat(root_path,'\ave_',condition{1,i},'_Adults_Ace_gPPI_Value.xls'));
    c=xlsread(strcat(root_path,'\ave_',condition{1,i},'_Children_Ace_gPPI_Value.xls'));
    com=[a;c];
    data=mat2cell(com,ones(298,1),ones(81,1));
    ace=[attributes;data];
    cd('D:\JM_Neo_BART\TST_Ace_Analyses\PPI\Results\Ace_Value_PPI\xls\Int')
    xlswrite(strcat(condition{1,i},'_Ace_PPI_value_int.xls'),ace)
    clear com
end

disp('>>>>>>>>>>End<<<<<<<<<<')