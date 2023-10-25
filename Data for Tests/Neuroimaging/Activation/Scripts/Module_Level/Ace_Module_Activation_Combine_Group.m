%Written for BART Analyses (2019/09/03)
%Presented by Shamrockheart
%TST Ace Module on February 11, 2020

close all; clear all; clc
disp('>>>>>>>>>>Start<<<<<<<<<<')

root_path='D:\JM_Neo_BART\TST_Ace_Analyses\Activation\Results\TST_Ace_Module_Value_Activation\xls';
condition={'pump','cashout','explode'};
attributes={'Group','Control','Approach','Avoidance'};
for m=1:298
    if m>80
        group{m,1}='Children';
    else
        group{m,1}='Adults';
    end
end

for i=1:3
    a=xlsread(strcat(root_path,'\',condition{1,i},'_Adults_TST_Ace_Module_activation.xls'));
    c=xlsread(strcat(root_path,'\',condition{1,i},'_Children_TST_Ace_Module_activation.xls'));
    com=[a;c];
    data=mat2cell(com,ones(298,1),ones(4,1));
    ace=[attributes;data];
    cd('D:\JM_Neo_BART\TST_Ace_Analyses\Activation\Results\TST_Ace_Module_Value_Activation\xls\Int')
    xlswrite(strcat(condition{1,i},'_TST_Ace_Module_activation_int.xls'),ace)
    xlswrite(strcat(condition{1,i},'_TST_Ace_Module_activation_int.xls'),group,'Sheet1','A2:A299')
    clear com
end

disp('>>>>>>>>>>End<<<<<<<<<<')