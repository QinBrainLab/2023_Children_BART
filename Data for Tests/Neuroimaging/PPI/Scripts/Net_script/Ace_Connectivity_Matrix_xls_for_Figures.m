%Written for BART Analyses (2019/05/14)
%Presented by Shamrockheart
%ver_19.12.23 (average of upper + lower; for Heatmap script)
%TST Ace ver_20.02.18

close all; clear all; clc
disp('>>>>>>>>>>Start<<<<<<<<<<')

root_path='D:\JM_Neo_BART\TST_Ace_Analyses\PPI\Results\Ace_Value_PPI';
group={'Adults','Children'};
condition={'pump','cashout','explode'};
roi={'dACC','DLPFC','VMPFC','NAc','Caudate','Putamen','Amygdala','Insula','Hippocampus'};

for u=1:2
    group_path=strcat(root_path,'\',group{1,u});
    for v=1:3
        com=zeros(9);
        condition_path=strcat(group_path,'\',condition{1,v});
        load(strcat(condition_path,'\Ace_Value_PPI.mat'))
        num=size(data_mean,3);
        for w=1:num
            sub=data_mean(:,:,w);
            sub(logical(eye(size(sub))))=nan(1,9);
            for x=1:9
                for y=1:9
                    temp(x,y)=nanmean([sub(x,y),sub(y,x)]);
                end
            end
            com=com+temp;
        end
        avg=com./num;
        data=mat2cell(avg,ones(9,1),ones(9,1));
        ace=[roi;data];
        cd('D:\JM_Neo_BART\JM_Neo_Figures\JM_Neo_Heatmap\Input\Heatmap_Ace')
        xlswrite(strcat(condition{1,v},'_',group{1,u},'_Ace_CM_ave.xls'), ace)
        clear com
    end
end

disp('>>>>>>>>>>End<<<<<<<<<<')