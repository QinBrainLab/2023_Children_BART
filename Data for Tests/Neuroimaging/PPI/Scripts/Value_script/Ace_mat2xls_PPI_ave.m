%Written for BART Analyses
%Presented by JM
%TST Ace on February 17, 2020

close all; clear all; clc
disp('>>>>>>>>>>Start<<<<<<<<<<')

type={'Ace_Value_Activation','Ace_Value_PPI'};
group={'Adults','Children'};
condition={'pump','cashout','explode'};
root_path='D:\JM_Neo_BART\TST_Ace_Analyses\PPI\Results';
seed_ROI={'dACC','DLPFC','VMPFC','NAc','Caudate','Putamen','Amygdala','Insula','Hippocampus'};
mask_ROI=seed_ROI;
con=[];
con_data=[];

for u=2
    type_path=strcat(root_path,'\',type{1,u});
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
                    sub=data_mean(:,:,n);
                    sub(logical(eye(size(sub))))=nan(1,9);
                    for a=1:9
                        for b=1:9
                            temp(a,b)=nanmean([sub(a,b),sub(b,a)]);
                        end
                    end
                    seed=temp(1:9,m);
                    tp(n,1:9)=seed';
                end
                con_data=[con_data,tp];
            end
            rs(:,2:82)=con_data;
            data=mat2cell(rs,ones(num,1),ones(82,1));
            ace=[attributes;data];
            % cd(condition_path)
            cd('D:\JM_Neo_BART\TST_Ace_Analyses\PPI\Results\Ace_Value_PPI\xls')
            xlswrite(strcat('ave_',condition{1,w},'_',group{1,v},'_Ace_gPPI_Value.xls'),ace)
        end
    end
end

disp('>>>>>>>>>>End<<<<<<<<<<')