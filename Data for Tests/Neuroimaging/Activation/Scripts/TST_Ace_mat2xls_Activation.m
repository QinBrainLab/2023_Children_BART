%Written for BART Analyses
%Presented by Shamrockheart
%Modified on October 9, 2018
%TST Ace on February 11, 2020

close all; clear all; clc
disp('>>>>>>>>>>Start<<<<<<<<<<')

type={'TST_Ace_Value_Activation','OFC_Value_PPI'};
group={'Adults','Children'};
condition={'pump','cashout','explode'};
% root_path='D:\JM_Neo_BART\JM_Neo_Results';
ROI={'dACC','DLPFC','VMPFC','NAc','Caudate','Putamen','Amygdala','Insula','Hippocampus'};
attributes=['Group',ROI];
con=[];
con_data=[];

for u=1
    type_path='D:\JM_Neo_BART\TST_Ace_Analyses\Activation\Results\TST_Ace_Value_Activation';
    for v=2
        group_path=strcat(type_path,'\',group{1,v});
        for w=3
            condition_path=strcat(group_path,'\',condition{1,w});
            load(strcat(condition_path,'\',type{1,u},'.mat'))
            num=size(data_mean,1);
            rs(:,1)=ones(num,1).*v;
            rs=[rs,data_mean];
            cd('D:\JM_Neo_BART\TST_Ace_Analyses\Activation\Results\TST_Ace_Value_Activation\xls')
            data=mat2cell(rs,ones(num,1),ones(10,1));
            ace=[attributes;data];
            xlswrite(strcat(condition{1,w},'_',group{1,v},'_TST_Ace_activation.xls'),ace)
        end
    end
end

disp('>>>>>>>>>>End<<<<<<<<<<')