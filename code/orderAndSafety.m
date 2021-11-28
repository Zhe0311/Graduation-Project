%% init
clear;
clc;
%% 确定基本参数
p = 0.5;
num = 11;
num_1 = num - 1;
ve = 15;
%%
meanStableTime = zeros(length(p), 1);
meanPDT = zeros(length(p), 1);
meanPDT_AV = zeros(length(p), 1);
meanPDT_HV = zeros(length(p), 1);
Gmax = zeros(length(p), 1);
% PDT_big = [];
%         PDT_small = [];
%         index_big = [];
%         index_small = [];
%         x1 = [];
%         x2 = [];
%% begin simulation
for i = 1 : 1 : length(p)
    for j = 1 : 1 : length(ve)
        disp("simulating... -- P: " + num2str(i) + "/" + num2str(length(p)) + ",  ve: "+ num2str(j) + "/" + num2str(length(ve)));
        %% 确定参数
        AV_num = floor(num_1 * p(i));
        rankNumber = factorial(10) / (factorial(AV_num) * factorial(10-AV_num)); % 不同p对应不同的排列种类数
        ifstable = 0;
        % Gmax = 0;
        
        stableIndex = zeros(rankNumber, 1);
        PDT_rate = zeros(rankNumber, 1);
        PDT_AV = zeros(rankNumber, 1);
        PDT_HV = zeros(rankNumber, 1);
        PDT_HV_AV = zeros(rankNumber, 1);
        PDT_HV_HV = zeros(rankNumber, 1);
        TET = zeros(rankNumber, 1);
        TIT = zeros(rankNumber, 1);
        TET_AV = zeros(rankNumber, 1);
        TIT_AV = zeros(rankNumber, 1);
        TET_HV = zeros(rankNumber, 1);
        TIT_HV = zeros(rankNumber, 1);
        
        
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
        
        for rank = 1 : 1 : rankNumber
            temp = [1,0,1,0,1,0,1,0,1,0];
            [PDT_rate(rank), PDT_HV_AV(rank), PDT_HV_HV(rank), PDT_AV(rank), PDT_HV(rank), ifstable, stableIndex(rank), TET(rank), TIT(rank),TET_AV(rank), TET_HV(rank),TIT_AV(rank), TIT_HV(rank)] = simulation(num, labels(rank, :), ve(j));
%                 [PDT_rate(rank), PDT_HV_AV(rank), PDT_HV_HV(rank), PDT_AV(rank), PDT_HV(rank), ifstable, stableIndex(rank), TET(rank), TIT(rank),TET_AV(rank), TET_HV(rank),TIT_AV(rank), TIT_HV(rank)] = simulation(num, temp, ve(j));
        end
        Gmax(i) = stableIndex(1);
        meanPDT(i) = mean(PDT_rate);
        meanPDT_AV(i) = mean(PDT_AV);
        meanPDT_HV(i) = mean(PDT_HV);
%         index = getFrontIndex(labels);
%         meanPDT_big(i) = mean(PDT_rate(index >= 0.5));
%         meanPDT_small(i) = mean(PDT_rate(index < 0.5));
%         PDT_big = [PDT_big, PDT_rate(index >= 0.5)'];
%         PDT_small = [PDT_small, PDT_rate(index < 0.5)'];
%         index_big = [index_big, index(index >= 0.5)'];
%         index_small = [index_small, index(index < 0.5)'];
%         x1 = [x1, (Gmax(i)*ones(length(index(index >= 0.5)),1))'];
%         x2 = [x2, (Gmax(i)*ones(length(index(index < 0.5)),1))'];
%         if i == 1
%             
%         else
%             scatter(Gmax(i)*ones(length(index_big), 1), PDT_big, 'r');
%             hold on;
%             scatter(Gmax(i)*ones(length(index_small), 1), PDT_small, 'b');
%             hold on;
%         end
        if ifstable % 稳定
            disp("p: " + num2str(p(i)) + ", ve: " + num2str(ve(j)) + " -- stable")
            stabletime = stableIndex(stableIndex ~= -1);
            % scatter(p(i)*ones(length(TIT), 1), TIT, "b");
            % hold on;
            meanStableTime(i) = mean(TIT);
        else % 不稳定
            disp("unstable");
            % myplot(rankNumber, labels, PDT_rate);
            % legend(["10","15","20"]);
        end
    end
end

% scatter(x1, PDT_big, 'r', 'DisplayName', 'FrontIndex bigger than 0.5');
% hold on;
% scatter(x2, PDT_small, 'b', 'DisplayName', 'FrontIndex less than 0.5');
% hold on;
% 
% plot(Gmax, meanPDT, "b", 'DisplayName', 'mean(all data)');
% hold on;
% plot(Gmax, meanPDT_big, "r", 'DisplayName', 'mean(FrontIndex bigger than 0.5)');
% hold on;
% plot(Gmax, meanPDT_small, "g", 'DisplayName', 'mean(FrontIndex less than 0.5)');
% hold on;
% % legend(["FrontIndex bigger than 0.5", "FrontIndex less than 0.5", "mean"]);
% legend();
% xlabel("传递函数最大增益倍数");
% ylabel("PDT");

plot(Gmax, meanPDT, "k", 'DisplayName', 'mean(all)');
hold on;
plot(Gmax, meanPDT_AV, "r", 'DisplayName', 'mean(AV)');
hold on;
plot(Gmax, meanPDT_HV, "b", 'DisplayName', 'mean(HV)');
hold on;
legend();
xlabel("传递函数最大增益倍数");
ylabel("PDT");
