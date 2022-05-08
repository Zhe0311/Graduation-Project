%% init
clear;
clc;
%% 确定基本参数
p = 0.5;
num = 11;
num_1 = num - 1;
ve = 20;
%%
G = [];
crashtime = [];
stableTime = [];
Gmax = zeros(length(p), length(ve));
meanPDT_rate = [];
Crash = zeros(length(p), length(ve));
plist = [];
table = [];
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
        all_cnt = 0;
        this_cnt = 0;
        safeTable = [];
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
            [PDT_rate, ifstable, GmaxList, stableIndex, crash] = simulation(num, labels(rank, :), ve(j));
            if ifstable && crash{1} == false && stableIndex ~= -1
                stabletime = stabletime + stableIndex;
                Pdt = Pdt + PDT_rate;
                counter = counter + 1;
            end
  
            if crash{1} == 1 % 如果没有发生碰撞
                DispIndex = getDispIndex(labels); % 计算空间分布指数
                FrontIndex = getFrontIndex(labels); % 计算靠前分布指数
                % safeTable =  [safeTable; [crash{4}, DispIndex(rank), FrontIndex(rank)]];
                safeTable =  [safeTable; [crash{4}, -1, FrontIndex(rank)]];
                all_cnt = all_cnt + 1;
                if (labels(rank, crash{4}) == 0) && (labels(rank, crash{4}-1) == 0)
                    this_cnt = this_cnt + 1;
                end

            end
            if crash{1} && ifstable == 0 % 如果发生了碰撞
                G = [G; stableIndex];
                crashtime = [crashtime; crash{2}];
            end
            table = [table; [p(i), ve(j), ifstable, stableIndex, GmaxList, labels(rank, :), crash]];
        end
        
        if isempty(safeTable) == 0
            crash_time_list = safeTable(:, 1);
            index_unique = sort(unique(safeTable(:, 3)));
            y = zeros(length(index_unique), 1);
            for cnt = 1 : 1 : length(index_unique)
                y(cnt) = mean(crash_time_list(safeTable(:, 3) == index_unique(cnt)));
            end
            plot(index_unique, y, 'DisplayName',['p=', num2str(p(i))]);
            hold on;
            xlabel('Index_{front}');
            ylabel('追尾车辆下标');
            legend();
        end 

        Gmax(i, j) = stableIndex;

        if ifstable % 稳定
            disp("p: " + num2str(p(i)) + ", ve: " + num2str(ve(j)) + " -- stable");
        else % 不稳定
            disp("unstable");
            % myplot(rankNumber, labels, PDT_rate);
            % legend(["10","15","20"]);
        end
    end
%     figure();
%     scatter(safeTable(:, 2), safeTable(:, 1));
% %     hold on;
% %     crash_time_list = safeTable(:, 1);
% %     index_unique = sort(unique(safeTable(:, 2)));
% %     y = zeros(length(index_unique), 1);
% %     for i = 1 : 1 : length(index_unique)
% %         y(i) = mean(crash_time_list(safeTable(:, 2) == index_unique(i)));
% %     end
% %     plot(index_unique, y);
%     xlabel('Index_{disp}');
%     ylabel('追尾车辆下标');
%     figure();

    % scatter(safeTable(:, 3), safeTable(:, 1));
    % hold on;
%     crash_time_list = safeTable(:, 1);
%     index_unique = sort(unique(safeTable(:, 3)));
%     y = zeros(length(index_unique), 1);
%     for i = 1 : 1 : length(index_unique)
%         y(i) = mean(crash_time_list(safeTable(:, 3) == index_unique(i)));
%     end
%     plot(index_unique, y);
%     hold on;
%     xlabel('Index_{front}');
%     ylabel('追尾车辆下标');
%     disp(corrcoef(safeTable(:, 2), safeTable(:, 1)));
%     disp(corrcoef(safeTable(:, 3), safeTable(:, 1)));
end


