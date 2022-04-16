%% initial
clc;
clear;

%% load data
datas = load('datac.mat').datac;  % all information of 98 records
drivers = load('drivers.mat').anatable;  % drivers' information

%% perimeters
smooth_index = 20;
postpro_index = 5;

valid = find(drivers(:, 2) == 1);
HumanDriver = find(drivers(:, 3) == 0);
validIndex = intersect(valid, HumanDriver);

THW_up = [];
THW_down = [];
SM_up = [];
SM_down = [];

for index = validIndex'
    data = datas{index};
    
    [n, ~] = size(data);
    t = 1 : 1 : n;
    v_midCar = data(:, 9);
    
    % 平滑
    v_smooth = smooth(v_midCar, smooth_index);

    % 一阶差分
    diff_v_midCar = v_smooth(2:end, :) - v_smooth(1:end-1, :);

    % 比较
    blocks = postprocess(sign([1; diff_v_midCar]), postpro_index);
    
    % 
    up = find(blocks == 1);
    down = find(blocks == -1);
    
    data_up = data(up, :);
    data_down = data(down, :);
    
    SM_up_all = getSM(data_up, 2);
    SM_down_all = getSM(data_down, 2);

    valid_SM_up = SM_up_all(SM_up_all <= 2);
    valid_SM_up = valid_SM_up(valid_SM_up >= 0);
    valid_SM_down = SM_down_all(SM_down_all <= 2);
    valid_SM_down = valid_SM_down(valid_SM_down >= 0);

    THW_up_all = getTHW(data_up, 2);
    THW_down_all = getTHW(data_down, 2);

    valid_THW_up = THW_up_all(THW_up_all <= 10);
    valid_THW_up = valid_THW_up(valid_THW_up >= 0);
    valid_THW_down = THW_down_all(THW_down_all <= 10);
    valid_THW_down = valid_THW_down(valid_THW_down >= 0);

    THW_up = [THW_up; valid_THW_up];
    THW_down = [THW_down; valid_THW_down];
    SM_up = [SM_up; valid_SM_up];
    SM_down = [SM_down; valid_SM_down];
end

THW_up_info = tabulate(THW_up);
THW_down_info = tabulate(THW_down);
SM_up_info = tabulate(SM_up);
SM_down_info = tabulate(SM_down);

figure(1);
THW_up_Histogram = histogram(THW_up);
xlabel("THW");
ylabel("频次");
figure(2);
THW_down_Histogram = histogram(THW_down);
xlabel("THW");
ylabel("频次");
figure(3);
SM_up_Histogram = histogram(SM_up);
xlabel("SM");
ylabel("频次");
figure(4);
SM_down_Histogram = histogram(SM_down);
xlabel("SM");
ylabel("频次");

[h_THW, p_THW] = ttest2(THW_up, THW_down);
[h_SM, p_SM] = ttest2(SM_up, SM_down);

function res = postprocess(signal, postpro_index)
% - 翻转区间长度小于postpro_index的区间以进一步消除毛刺
    len = 0;
    for i = 2 : 1 : length(signal)
        if signal(i) == signal(i-1)
            len = len + 1;
        else
            if len < postpro_index
                signal(i-len-1: i-1) = -1 .* signal(i-len-1: i-1);
                len = postpro_index + 1; % 确保大于阈值
            else
                len = 0;
            end
        end
    end
    res = signal;
end

function SM = getSM(data, position)
% ----
% addData - 
% index - 第几组数据
% position - 第二辆车(position=2) or 第三辆车(position=3)
% ----
    if position == 2
        SM = 1 - ((0.15.*data(:, 9)./3.6)./(data(:, 13))) - (((data(:, 9)./3.6+data(:, 6)./3.6).*(data(:, 9)./3.6-data(:, 6)./3.6))./(1.5*9.8.*(data(:, 13)))); 
    else
        SM = 1 - ((0.15.*data(:, 12)./3.6)./(data(:, 14))) - (((data(:, 12)./3.6+data(:, 9)./3.6).*(data(:, 12)./3.6-data(:, 9)./3.6))./(1.5*9.8.*(data(:, 14)))); 
    end
end

function THW = getTHW(data, position)
% ----
% addData - 
% index - 第几组数据
% position - 第二辆车(position=2) or 第三辆车(position=3)
% ----
    if position == 2
        THW = data(:, 13) ./ data(:, 9) .* 3.6;
    else
        THW = data(:, 14) ./ data(:, 12) .* 3.6;
    end
end