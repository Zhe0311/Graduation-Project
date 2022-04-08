%% initial
clc;
clear;

%% load data
data = load('datac.mat').datac;  % all information of 98 records
drivers = load('drivers.mat').anatable;  % drivers' information

valid = find(drivers(:, 2) == 1);
HumanDriver = find(drivers(:, 3) == 0);

validMidCarIndex = intersect(valid, HumanDriver);
validEndCarIndex = valid;

THWMidCar = [];
THWEndCar = [];
for index = validMidCarIndex'
    allTHW = getTHW(data, index, 2);
    validTHW = allTHW(allTHW <= 10);
    validTHW = validTHW(validTHW >= 0);
    THWMidCar = [THWMidCar; validTHW];
end
for index = validEndCarIndex'
    allTHW = getTHW(data, index, 3);
    validTHW = allTHW(allTHW <= 10);
    validTHW = validTHW(validTHW >= 0);
    THWEndCar = [THWEndCar; validTHW];
end
MidCarInfo = tabulate(THWMidCar);
EndCarInfo = tabulate(THWEndCar);

figure(1);
midCarHistogram = histogram(THWMidCar);
figure(2);
endCarHistogram = histogram(THWEndCar);

[p1, h1] = ranksum(THWMidCar, THWEndCar, 0.05);
[p2, h2] = ranksum(sort(THWMidCar), sort(THWEndCar), 0.05);
h = kstest2(THWMidCar, THWEndCar);
% h_ttest = ttest2(THWMidCar, THWEndCar);
[h_ttest, p_ttest] = ttest2(THWMidCar, THWEndCar);
% [h_ttest, p_ttest] = ttest2(THWMidCar, THWEndCar, 'Vartype','unequal');

function THW = getTHW(allData, index, position)
% ----
% addData - 
% index - 第几组数据
% position - 第二辆车(position=2) or 第三辆车(position=3)
% ----
    data = allData{index};
    if position == 2
        THW = data(:, 13) ./ data(:, 9) .* 3.6;
    else
        THW = data(:, 14) ./ data(:, 12) .* 3.6;
    end
end