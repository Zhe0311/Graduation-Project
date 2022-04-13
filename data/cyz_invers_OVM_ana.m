%% initial
clc;
clear;

%% load data
datas = load('datac.mat').datac;  % all information of 98 records
drivers = load('drivers.mat').anatable;  % drivers' information

valid = find(drivers(:, 2) == 1);
HumanDriver = find(drivers(:, 3) == 0);

validMidCarIndex = intersect(valid, HumanDriver);

index = validMidCarIndex(20);
data = datas{index};
v = data(:, 9);
h = data(:, 14);

v_front = v(1:100, :);
h_front = h(1:100, :);

v_end = v(101:end, :);
h_end = h(101:end, :);

figure(1);
plot(h, v);
xlabel("与后车距离");
ylabel("速度");
% scatter(v, h);
% figure(2);
% scatter(v_front, h_front);
% figure(3);
% scatter(v_end, h_end);
