%% init
clear;
clc;
%% 确定基本参数
p = 0 : 0.1 : 1;
num = 11;
num_1 = num - 1;
ve = 10 : 2 : 30;
%%
G = [];
crashtime = [];
stableTime = [];
Gmax = zeros(length(p), length(ve));
meanPDT_rate = [];
Crash = zeros(length(p), length(ve));
plist = [];
%% begin simulation
for i = 1 : 1 : length(p)
    for j = 1 : 1 : length(ve)
        disp("simulating... -- P: " + num2str(i) + "/" + num2str(length(p)) + ",  ve: "+ num2str(j) + "/" + num2str(length(ve)));
        %% 确定参数
        AV_num = floor(num_1 * p(i));
        rankNumber = factorial(10) / (factorial(AV_num) * factorial(10-AV_num)); % 不同p对应不同的排列种类数
        ifstable = 0;
        % Gmax = 0;
        ifCrashed = 0;
        
        stableIndex = zeros(rankNumber, 1);
        % PDT_rate = zeros(rankNumber, 1);
        TET = zeros(rankNumber, 1);
        TIT = zeros(rankNumber, 1);
        
        
        
        labels = zeros(rankNumber, num_1);
        cnt = 0;
        while cnt < rankNumber
            label = zeros(num_1, 1);
            rand = randperm(num_1);
            label(rand(1:(AV_num))) = 1;
            flag = 0;
            for k = 1 : 1 : cnt
                if sum(labels(k, :) == label') == 10
                    flag = 1;
                    break;
                end
            end
            if flag == 0
                cnt = cnt + 1;
                labels(cnt, :) = label;
            end
        end
        Pdt = 0;
        stabletime = 0;
        counter = 0;
        for rank = 1 : 1 : rankNumber
            [PDT_rate, ifstable, stableIndex, crash] = simulation(num, labels(rank, :), ve(j));
            if ifstable && crash{1} == false && stableIndex ~= -1
                stabletime = stabletime + stableIndex;
                Pdt = Pdt + PDT_rate;
                counter = counter + 1;
            end
            if crash{1} && ifstable == 0 % 如果发生了碰撞
                G = [G; stableIndex];
                crashtime = [crashtime; crash{2}];
            end
        end

        if ifstable % 稳定
            disp("p: " + num2str(p(i)) + ", ve: " + num2str(ve(j)) + " -- stable")
            meanPDT_rate = [meanPDT_rate, Pdt/counter];
            stableTime = [stableTime, stabletime/counter];
            plist = [plist, 0.1*(i-1)];
        else % 不稳定
            disp("unstable");
            % myplot(rankNumber, labels, PDT_rate);
            % legend(["10","15","20"]);
        end
    end
end


