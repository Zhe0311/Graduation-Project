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

SMMidCar = [];
SMEndCar = [];
for index = validMidCarIndex'
    allSM = getSM(data, index, 2);
    validSM = allSM(allSM <= 2);
    validSM = validSM(validSM >= 0);
    SMMidCar = [SMMidCar; validSM];
end
for index = validEndCarIndex'
    allSM = getSM(data, index, 3);
    validSM = allSM(allSM <= 2);
    validSM = validSM(validSM >= 0);
    SMEndCar = [SMEndCar; validSM];
end
MidCarInfo = tabulate(SMMidCar);
EndCarInfo = tabulate(SMEndCar);

figure(1);
midCarHistogram = histogram(SMMidCar);
figure(2);
endCarHistogram = histogram(SMEndCar);

[p1, h1] = ranksum(SMMidCar, SMEndCar, 0.05);
[p2, h2] = ranksum(sort(SMMidCar), sort(SMEndCar), 0.05);
h = kstest2(SMMidCar, SMEndCar);
% h_ttest = ttest2(THWMidCar, THWEndCar);
[h_ttest, p_ttest] = ttest2(SMMidCar, SMEndCar);
% [h_ttest, p_ttest] = ttest2(THWMidCar, THWEndCar, 'Vartype','unequal');

function SM = getSM(allData, index, position)
% ----
% addData - 
% index - 第几组数据
% position - 第二辆车(position=2) or 第三辆车(position=3)
% ----
    data = allData{index};
    if position == 2
        SM = 1 - ((0.15.*data(:, 9)./3.6)./(data(:, 13))) - (((data(:, 9)./3.6+data(:, 6)./3.6).*(data(:, 9)./3.6-data(:, 6)./3.6))./(1.5*9.8.*(data(:, 13)))); 
    else
        SM = 1 - ((0.15.*data(:, 12)./3.6)./(data(:, 14))) - (((data(:, 12)./3.6+data(:, 9)./3.6).*(data(:, 12)./3.6-data(:, 9)./3.6))./(1.5*9.8.*(data(:, 14)))); 
    end
end