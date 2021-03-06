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

index = validIndex(3);
data = datas{index};

[n, ~] = size(data);
t = 1 : 1 : n;
v_midCar = data(:, 6);
    
% 平滑
v_smooth = smooth(v_midCar, smooth_index);

% 一阶差分
diff_v_midCar = v_smooth(2:end, :) - v_smooth(1:end-1, :);

% 比较
blocks = postprocess(sign([1; diff_v_midCar]), postpro_index);
    
% 
up = find(blocks == 1);
down = find(blocks == -1);


SM_all = getSM(data, 2);

%valid_SM = SM_all(SM_all <= 2);
%valid_SM = valid_SM(valid_SM >= 0);

THW1_all = getTHW(data, 2);
THW2_all = getTHW(data, 3);

%valid_THW = THW_all(THW_all <= 10);
%valid_THW = valid_THW(valid_THW >= 0);

%% Plot
time = 1 : 1 : n;
v1 = data(:, 6);
v2 = data(:, 9);
v3 = data(:, 12);

begin = 70;

subplot(2, 1, 1);
plot(time(begin:end), v1(begin:end));
hold on;

subplot(2, 1, 1);
plot(time(begin:end), v2(begin:end));
hold on;

subplot(2, 1, 1);
plot(time(begin:end), v3(begin:end));
hold on;

xlabel("采样点下标");
ylabel("速度(m/s)");
legend(["v1", "v2", "v3"]);

subplot(2, 1, 2);
yyaxis left;
plot(time(begin:end), THW1_all(begin:end), '-b');
hold on;

subplot(2, 1, 2);
yyaxis left;
plot(time(begin:end), THW2_all(begin:end), '-k');
ylabel("THW");
hold on;

subplot(2, 1, 2);
yyaxis right;
plot(time(begin:end), SM_all(begin:end), '-r');
ylabel("SM");

xlabel("采样点下标");
legend(["THW1", "THW2", "SM"]);

% v_smooth = smooth(v_midCar, smooth_index);
% 
% diff_v_midCar = v_smooth(2:end, :) - v_smooth(1:end-1, :);
% blocks = postprocess(sign([1; diff_v_midCar]), postpro_index);
% 
% %% plot
% figure();
% subplot(1,2,1);
% plot(t, v_midCar);
% hold on;
% 
% subplot(1,2,1);
% plot(t, v_smooth);
% hold on;
% 
% subplot(1,2,1);
% plot(t, 50 + 15 .* blocks, 'r');
% 
% xlabel("采样点序号");
% ylabel("速度（km/h）");
% legend(["原始数据", "平滑后数据", "加减速区间"]);
% 
% subplot(1,2,2);
% plot(t, [1; diff_v_midCar]);
% hold on;
% 
% subplot(1,2,2);
% plot(t, blocks, 'r');
% 
% legend(["一阶差分结果", "加减速区间"]);
% xlabel("采样点序号");
% ylabel("速度差（km/h）");
% 
% up = find(blocks == 1);
% down = find(blocks == -1);

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
        THW = data(:, 14) ./ data(:, 9) .* 3.6;
    end
end