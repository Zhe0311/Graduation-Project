function myplot(rankNumber, labels, PDT_rate, PDT_AV, PDT_HV, PDT_HV_HV, PDT_HV_AV)

%     mid = sum(labels(1, :) == 1);
%     up = sum((11-mid) : 1 : 10);
%     low = sum(1 : 1 : mid);
% 
%     pos = zeros(rankNumber, 1);
%     for i = 1 : 1 : rankNumber
%         mid = labels(i, :) == 1;
%         summ = 0;
%         for j = 1 : 1 : 10
%             summ = summ + mid(j)*2^(10-j);
%         end
%         pos(i) = summ;
%     end

%% 
     pos = getDispIndex(labels);
%% 
%     for i = 1 : 1 : 252
%         pos(i) = sum(find(labels(i, :) == 1));
%     end

%     scatter(pos, PDT_HV, "k", 'DisplayName', 'all HVs');
%     hold on;
    scatter(pos, PDT_HV_AV, "r", 'DisplayName', 'HVs after AVs');
    hold on;
    scatter(pos, PDT_HV_HV, "b", 'DisplayName', 'HVs after HVs');
    hold on;
    xlabel("Ind_{disp}");
    ylabel("PDT");
    legend();
    % legend(["0","mean_0","0.1","mean_0.1","0.2","mean_0.2", "0.3","mean_0.3","0.4","mean_0.4", "0.5","mean_0.5",  "0.6","mean_0.6", "0.7","mean_0.7",  "0.8","mean_0.8", "0.9","mean_0.9", "1.0","mean_1.0", ]);
    hold on;



%     new_x = low : 1 : up;
%     new_y = zeros(up-low+1, 0);
%     for i = 1 : 1 : up-low+1
%         new_y(i) = mean(PDT_rate(find(pos == new_x(i))));
%     end
%     plot(new_x, new_y);
%     hold on;
end