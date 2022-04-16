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

index = validIndex(9);
data = datas{index};

[n, ~] = size(data);
t = 1 : 1 : n;
v_midCar = data(:, 9);

v_smooth = smooth(v_midCar, smooth_index);

diff_v_midCar = v_smooth(2:end, :) - v_smooth(1:end-1, :);
blocks = postprocess(sign([1; diff_v_midCar]), postpro_index);

%% plot
figure();
subplot(1,2,1);
plot(t, v_midCar);
hold on;

subplot(1,2,1);
plot(t, v_smooth);
hold on;

subplot(1,2,1);
plot(t, 50 + 15 .* blocks, 'r');

xlabel("采样点序号");
ylabel("速度（km/h）");
legend(["原始数据", "平滑后数据", "加减速区间"]);

subplot(1,2,2);
plot(t, [1; diff_v_midCar]);
hold on;

subplot(1,2,2);
plot(t, blocks, 'r');

legend(["一阶差分结果", "加减速区间"]);
xlabel("采样点序号");
ylabel("速度差（km/h）");

up = find(blocks == 1);
down = find(blocks == -1);

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