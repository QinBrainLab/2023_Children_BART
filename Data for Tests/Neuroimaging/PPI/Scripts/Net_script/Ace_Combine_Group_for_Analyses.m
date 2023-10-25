%Written for BART Analyses (2019/09/03)
%Presented by Shamrockheart
%ver_19.12.23 (for subsequent analyses after matrix preproc)
%TST Ace ver_20.02.18

close all; clear all; clc
disp('>>>>>>>>>>Start<<<<<<<<<<')

root_path='D:\JM_Neo_BART\TST_Ace_Analyses\PPI\Results\Ace_Network_xls';
condition={'pump','cashout','explode'};
attributes={'Group','Control','Reward','Avoidance','Ctrl_Rwd','Ctrl_Avd','Rwd_Avd','OvA_Ctrl','OvA_Rwd','OvA_Avd','Seg_Ctrl','Seg_Rwd','Seg_Avd'};
for m=1:298
    if m>80
        group{m,1}='Children';
    else
        group{m,1}='Adults';
    end
end

for i=1:3
    a=xlsread(strcat(root_path,'\',condition{1,i},'_Adults_Ace_ave_net.xls'));
    c=xlsread(strcat(root_path,'\',condition{1,i},'_Children_Ace_ave_net.xls'));
    com=[a;c];
    data=mat2cell(com,ones(298,1),ones(13,1));
    ace=[attributes;data];
    cd('D:\JM_Neo_BART\TST_Ace_Analyses\PPI\Results\Ace_Network_xls\Int')
    xlswrite(strcat(condition{1,i},'_Ace_net_int.xls'),ace)
    xlswrite(strcat(condition{1,i},'_Ace_net_int.xls'),group,'Sheet1','A2:A299')
    clear com
end

disp('>>>>>>>>>>End<<<<<<<<<<')