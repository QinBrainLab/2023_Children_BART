%Written for BART Analyses
%Presented by JM
%Modified on November 8, 2019

close all; clear all; clc
disp('>>>>>>>>>>Start<<<<<<<<<<')

type={'OFC_Value_Activation','OFC_Value_PPI'};
group={'Adults','Children'};
condition={'pump','cashout','explode'};
root_path='D:\JM_Neo_BART\JM_Neo_Results';
seed_ROI={'ACC','DLPFC','VMPFC','OFC','Caudate','Putamen','Amygdala','Insula','Hippocampus'};
mask_ROI=seed_ROI;
con=[];
con_data=[];

for u=2
    type_path=strcat(root_path,'\',type{1,u},'_2019');
    for v=2
        group_path=strcat(type_path,'\',group{1,v});
        for w=3
            condition_path=strcat(group_path,'\',condition{1,w});
            for x=1:9
                for y=1:9
                    label{1,y}=strcat(seed_ROI{1,x},'_',mask_ROI{1,y});
                end
                con=[con,label];
            end
            attributes=['Group',con];
            load(strcat(condition_path,'\',type{1,u},'.mat'))
            num=size(data_mean,3);
            rs(:,1)=ones(num,1).*v;
            for m=1:9
                for n=1:num
                    seed=data_mean(1:9,m,n);
                    tp(n,1:9)=seed';
                end
                con_data=[con_data,tp];
            end
            rs(:,2:82)=con_data;
            data=mat2cell(rs,ones(num,1),ones(82,1));
            ace=[attributes;data];
            %             cd(condition_path)
            cd('D:\JM_Neo_BART\OFC_Upgrade\PPI\Value_xls')
            xlswrite(strcat(condition{1,w},'_',group{1,v},'_OFC_gPPI.xls'),ace)
        end
    end
end

disp('>>>>>>>>>>End<<<<<<<<<<')