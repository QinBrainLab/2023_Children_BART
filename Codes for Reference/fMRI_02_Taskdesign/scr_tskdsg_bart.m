% written by wu, modified by hao (ver_19.09.11)
% rock3.hao@gmail.com
% qinlab.BNU
clear; clc

%% Set up
datasets  = 'CBDHA';
test_time = 'A';
sessions  = 's02';

emerge_dir = 'C:\Users\hao1ei\OneDrive\Researchs\2019_HaoL_FuncBrainAtlas\Behavior\emerge';
output_dir = 'C:\Users\hao1ei\Desktop\xxx';

%% Acquire sublist and edata
sublist = csvread(fullfile(emerge_dir, ['list_t', test_time, '_bart_', datasets, '.csv']));
emrgdata = fullfile(emerge_dir, ['emrg_t', test_time, '_bart_', datasets, '.txt']);
eindex = {'Subject'; 'Block'; 'Trial'; 'IsBlow'; 'PumpNum'; 'PumpStep.OnsetTime'; ...
    'PumpStep.RT'; 'PumpStep.RESP'; 'ThreshNum'; 'total_reward'};

fid = fopen(emrgdata); edata_all = {}; cnt_edata = 1;
while ~feof(fid)
    linedata = textscan(fgetl(fid), '%s', 'Delimiter', '\t');
    edata_all(cnt_edata,:) = linedata{1}; cnt_edata = cnt_edata+1; %#ok<*SAGROW>
end
fclose(fid);

allindex = edata_all(1, :);
for iidx = 1:length(eindex)
    for irow = 2:length(edata_all)
        edata_filter(irow-1, iidx) = str2double(edata_all{irow, strcmp(allindex, eindex{iidx, 1})});
    end
end
edata_filter(:, 7)=edata_filter(:, 7) / 1000;

for isub = 1:size(sublist, 1)
    temp_onset = edata_filter(edata_filter(:,1) == sublist(isub, 1), 6);
    edata_filter(edata_filter(:,1) == sublist(isub, 1), 6) = (temp_onset - temp_onset(1, 1)) / 1000;
end

% 
% % choose win data
% win_all_01 = cell(size(sublist, 1), 1);
% for isub = 1:size(sublist, 1)
%     temp = edata_filter(edata_filter(:, 1) == sublist(isub, 1), :);
%     temp_win = temp(temp(:, 8) == 2, 2);
%     win_all_01{isub, 1} = temp(ismember(temp(:, 2), temp_win), 1:10);
% end
% 
% % choose win data in another way
% win_all_02 = [];
% for isub = 1:size(sublist, 1)
%     win_all_02 = [win_all_02; edata_filter(edata_filter(:, 1) == sublist(isub, 1) & edata_filter(:, 8)==2, 1:10)]; %#ok<*AGROW>
% end
% 
% % choose loss data
% loss_all_01 = cell(size(sublist, 1), 1);
% for isub = 1:size(sublist, 1)
%     temp = edata_filter(edata_filter(:, 1) == sublist(isub, 1), :);
%     temp_loss = temp(temp(:, 4) == 1, 2);
%     loss_all_01{isub, 1} = temp(ismember(temp(:, 2), temp_loss), 1:10);
% end
% 
% % choose loss data in another way
% loss_all_02 = [];
% for isub = 1:size(sublist, 1)
%     loss_all_02 = [loss_all_02; edata_filter(edata_filter(:, 1) == sublist(isub, 1) & edata_filter(:, 4) == 1, 1:10)];
% end
% 
% % choose pumps data
% pumps_all = edata_filter;
% pumps_all(pumps_all(:, 8) == 2 | pumps_all(:, 8) == 3 | pumps_all(:, 4) == 1, :) = [];
% 
% % count number
% for isub = 1:size(sublist, 1)
%     temp_num = tabulate(pumps_all(pumps_all(:, 1) == sublist(isub, 1), 1));
%     number(isub, [2, 3])= temp_num(isub, [1, 2]); % subject_id & total number of pumps
%     number(isub, 4) = max(edata_filter(edata_filter(:, 1)== sublist(isub, 1), 2)); % total number of balloons
%     number(isub, 5) = max(edata_filter(edata_filter(:, 1)== sublist(isub, 1), 10)); % total number of (adjusted) win-pumps
%     number(isub, 6) = sum(edata_filter(edata_filter(:, 1)== sublist(isub, 1) & edata_filter(:, 8) == 2, 8)) / 2; % total number of win-balloons
%     number(isub, 7) = number(isub, 3) - number(isub, 5); % total number of loss-pumps
%     number(isub, 8) = sum(edata_filter(edata_filter(:, 1) == sublist(isub, 1) & edata_filter(:, 4) == 1, 4)); % total number of loss-balloons
% end
% 
% % count AVE_number
% number_ave = number(:, [1 2]);
% number_ave(:, 3) = number(:, 3)./number(:, 4); % ave_all pumps
% number_ave(:, 4) = number(:, 5)./number(:, 6); % ave_adj pumps
% 
% % count RT
% rt(:, [1 2]) = number(:, [1 2]);
% for isub = 1:size(sublist, 1)
%     rt(isub, 3) = nanmean(pumps_all(pumps_all(:, 1) == sublist(isub, 1), 7)); % ave_RT of all pumps
%     temp6 = win_all_01{isub}(:, :);
%     temp6(temp6(:, 8) == 3 | temp6(:, 8) == 2, :) = [];
%     rt(isub, 4) = nanmean(temp6(:, 7)); % ave_RT of adj pumps
%     rt(isub, 5) = nanmean(win_all_02(win_all_02(:, 1) == sublist(isub, 1), 7)); % ave_RT of win
% end

win = edata_filter(edata_filter(:, 8) == 2, [1 2 6 7]);
loss = edata_filter(edata_filter(:, 4) == 1, [1 2 6 7]);
pump = edata_filter(:, [1 2 6 7 9]);
pump(ismember(edata_filter(:, 8), 2) | ismember(edata_filter(:, 8), 3) | ismember(edata_filter(:, 4), 1), :) = [];
pump(:, 7) = detrend(pump(:, 5), 'constant');

pump_time = cell(size(sublist, 1), 1);
for isub = 1:size(sublist, 1)
    subdata = pump(pump(:, 1) == sublist(isub, 1), :);
    trials = unique(subdata(:, 2));
    for itrial = 1:length(trials)
        trialrows = find(subdata(:, 2) == trials(itrial));
        pump_time{isub}(itrial, 1) = trials(itrial,1);
        pump_time{isub}(itrial, 2) = subdata( trialrows(1),3);
        pump_time{isub}(itrial, 3) = subdata( trialrows(end),3)+subdata( trialrows(end),4);
        pump_time{isub}(itrial, 4) = pump_time{isub}(itrial, 3)- pump_time{isub}(itrial, 2);
        pump_time{isub}(itrial, 5) = nanmean(subdata( trialrows(:),5));
        pump(pump(:, 1) == sublist(isub, 1) & pump(:, 2) == trials(itrial), 6) = pump(pump(:, 1) == sublist(isub, 1) & pump(:, 2) == trials(itrial), 5) - pump_time{isub}(itrial, 5);
    end
    pump_time{isub}(:, 6) = pump_time{isub}(:, 5) - mean(pump_time{isub}(:, 5));
end

loss_time = cell(size(sublist, 1), 1);
for isub = 1:size(sublist, 1)
    loss_time{isub}(:, [1 2 3]) =loss( loss(:,1) == sublist(isub, 1), [2 3 4]);
    loss_time{isub}(:, 4) = ( loss_time{isub}(:, 3) + 1.5);
end

win_time=cell(size(sublist, 1),1);
for isub = 1:size(sublist, 1)
    win_time{isub}(:, [1 2 3]) = win( win(:, 1) == sublist(isub, 1), [2 3 4]);
    win_time{isub}(:, 4) = ( win_time{isub}(:, 3) + 1.5);
end

for isub = 1:size(sublist, 1)
    onset_pump = pump(pump(:, 1) == sublist(isub, 1), 3);
    duration_pump = pump(pump(:, 1) == sublist(isub, 1), 4);
    parameter_pump = pump(pump(:, 1) == sublist(isub, 1), 6);
    onset_cashout = win_time{isub}(:, 2);
    duration_cashout = win_time{isub}(:, 4);
    onset_explode = loss_time{isub}(:, 2);
    duration_explode = loss_time{isub}(:, 4);
    
    % Save experimental design
    if sublist(isub,1) < 10
        subid = ['000', num2str(sublist(isub,1))];
    elseif sublist(isub,1) > 9 && sublist(isub,1) < 100
        subid = ['00', num2str(sublist(isub,1))];
    elseif sublist(isub,1) > 99
        subid = ['0', num2str(sublist(isub,1))];
    end
    save_dir = fullfile(output_dir, ['sub-', datasets, subid, test_time], ...
        ['ses-', sessions], 'func');
    if ~exist(save_dir, 'dir'); mkdir(save_dir); end
    
    taskfile = fullfile(save_dir, ['sub-', datasets, subid, test_time, ...
        '_ses-', sessions, '_task-bart_events.m']);
    tskdsg = fopen(taskfile, 'a');
    if exist(taskfile, 'file'); delete(taskfile); end
    fprintf(tskdsg, '%s\n', 'sess_name = ''bart'';');
    
    fprintf(tskdsg, '%s\n','names{1} = [''pump''];');
    onset_pump = num2cell(onset_pump);
    fprintf(tskdsg, ['onsets{1} = [', repmat('%f ', 1, length(onset_pump)), '];\n'], onset_pump{:});
    duration_pump = num2cell(duration_pump);
    fprintf(tskdsg, ['durations{1} = [', repmat('%f ', 1, length(duration_pump)), '];\n'], duration_pump{:});
    
    fprintf(tskdsg, '%s\n','names{2} = [''cashout''];');
    onset_cashout = num2cell(onset_cashout);
    fprintf(tskdsg, ['onsets{2} = [', repmat('%f ', 1, length(onset_cashout)), '];\n'], onset_cashout{:});
    duration_cashout = num2cell(duration_cashout);
    fprintf(tskdsg, ['durations{2} = [', repmat('%f ', 1, length(duration_cashout)), '];\n'], duration_cashout{:});
    
    fprintf(tskdsg, '%s\n','names{3} = [''explode''];');
    onset_explode = num2cell(onset_explode);
    fprintf(tskdsg, ['onsets{3} = [', repmat('%f ', 1, length(onset_explode)), '];\n'], onset_explode{:});
    duration_explode = num2cell(duration_explode);
    fprintf(tskdsg, ['durations{3} = [', repmat('%f ', 1, length(duration_explode)), '];\n'], duration_explode{:});
    
    fprintf(tskdsg, '%s\n','rest_exists = 1;');
    fprintf(tskdsg, '%s\n','save task_design.mat sess_name names onsets durations rest_exists');
    
    fclose(tskdsg);
end

%% Completed
disp(['Completed at: ', datestr(now)]);