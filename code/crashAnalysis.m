ifstable_stable = [];
GmaxList_stable = [];
labels_stable = [];
crashTime_stable = [];
crashIndex_stable = [];

ifstable_unstable = [];
GmaxList_unstable = [];
labels_unstable = [];
crashTime_unstable = [];
crashIndex_unstable = [];

for i = 1 : 1 : length(table)
    if table{i, 5} == 1 % 如果发生了碰撞
        if table{i, 1} == 1
            ifstable_stable = [ifstable_stable table{i, 1}];
            GmaxList_stable = [GmaxList_stable table{i, 3}];
            labels_stable = [labels_stable; table{i, 4}];
            crashTime_stable = [crashTime_stable table{i, 6}];
            crashIndex_stable = [crashIndex_stable table{i, 8}];
        else
            ifstable_unstable = [ifstable_unstable table{i, 1}];
            GmaxList_unstable = [GmaxList_unstable table{i, 3}];
            labels_unstable = [labels_unstable; table{i, 4}];
            crashTime_unstable = [crashTime_unstable table{i, 6}];
            crashIndex_unstable = [crashIndex_unstable table{i, 8}];
        end
    end
end

% Gmax = sort(unique(GmaxList_unstable(10, :)));
% Gmax = [1, Gmax];
% y = zeros(length(Gmax), 1);
% for i = 1 : 1 : length(Gmax)
%     y(i) = mean(crashIndex_unstable(GmaxList_unstable(10, :) == Gmax(i)));
% end
% y(1) = mean(crashIndex_stable);
% 
% scatter(GmaxList_stable(10, :), crashIndex_stable, 'g');
% hold on;
% scatter(GmaxList_unstable(10, :), crashIndex_unstable, 'k');
% hold on;
% scatter(Gmax, y, 'r');
% xlabel("传递函数最大增益");
% ylabel("追尾车辆下标");
% legend(["稳定车队", "不稳定车队", "平均情况"])

AV_stable = 0;
HV_stable = 0;
AV_unstable = 0;
HV_unstable = 0;
for i = 1 : 1 : length(ifstable_stable)
    if labels_stable(i, crashIndex_stable(i)) == 1
        AV_stable = AV_stable + 1;
    else
        HV_stable = HV_stable + 1;
    end
end
for i = 1 : 1 : length(ifstable_unstable)
    if labels_unstable(i, crashIndex_unstable(i)) == 1
        AV_unstable = AV_unstable + 1;
    else
        HV_unstable = HV_unstable + 1;
    end
end