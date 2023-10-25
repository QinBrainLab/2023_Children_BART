%Written for BART Analyses (2019/09/03)
%Presented by Shamrockheart
%ver_19.12.23 (Within + Pairwise + One verses all + Segeration)
%TST Ace ver_20.02.18

close all; clear all; clc
disp('>>>>>>>>>>Start<<<<<<<<<<')

root_path='D:\JM_Neo_BART\TST_Ace_Analyses\PPI\Results\Ace_Value_PPI';
group={'Adults','Children'};
condition={'pump','cashout','explode'};
attributes={'Group','Control','Reward','Avoidance','Ctrl_Rwd','Ctrl_Avd','Rwd_Avd','OvA_Ctrl','OvA_Rwd','OvA_Avd','Seg_Ctrl','Seg_Rwd','Seg_Avd'};
for u=1:2
    group_path=strcat(root_path,'\',group{1,u});
    for v=1:3
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
            ctrl=nanmean(nanmean(temp(1:3,1:3)));
            rwd=nanmean(nanmean(temp(4:6,4:6)));
            avd=nanmean(nanmean(temp(7:9,7:9)));
            c_r=(nanmean(nanmean(temp(1:3,4:6)))+nanmean(nanmean(temp(4:6,1:3))))./2;
            c_a=(nanmean(nanmean(temp(1:3,7:9)))+nanmean(nanmean(temp(7:9,1:3))))./2;
            r_a=(nanmean(nanmean(temp(4:6,7:9)))+nanmean(nanmean(temp(7:9,4:6))))./2;
            
            ctrl_ova=(c_r+c_a)./2;
            rwd_ova=(c_r+r_a)./2;
            avd_ova=(c_a+r_a)./2;
            
            seg_ctrl=(ctrl-ctrl_ova)./ctrl;
            seg_rwd=(rwd-rwd_ova)./rwd;
            seg_avd=(avd-avd_ova)./avd;
            
            value(w,:)=[ctrl,rwd,avd,c_r,c_a,r_a,ctrl_ova,rwd_ova,avd_ova,seg_ctrl,seg_rwd,seg_avd];
        end
        rs(:,1)=ones(num,1).*u;
        rs=[rs,value];
        data=mat2cell(rs,ones(num,1),ones(13,1));
        ace=[attributes;data];
        cd('D:\JM_Neo_BART\TST_Ace_Analyses\PPI\Results\Ace_Network_xls')
        xlswrite(strcat(condition{1,v},'_',group{1,u},'_Ace_ave_net.xls'),ace)
        clear rs
    end
end

disp('>>>>>>>>>>End<<<<<<<<<<')