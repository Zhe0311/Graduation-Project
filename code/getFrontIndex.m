function [frontIndex] = getFrontIndex(labels)
    AVNumber = sum(labels(1, :));   % 自动驾驶车辆数量
    number = length(labels(1, :));  % 车队车辆数（不包括头车）
    [len, ~] = size(labels);
    if AVNumber == 0
        frontIndex = -1;
        return;
    end
    
    frontIndexABS = zeros(len, 1);
    for i = 1 : 1 : len
        frontIndexABS(i) = sum(find(labels(i, :) == 1)) / (sum(number-AVNumber+1:1:number));
    end
    
    maxValue = max(frontIndexABS);
    minValue = min(frontIndexABS);
    frontIndex = zeros(len, 1);
    
    for i = 1 : 1 : len
        frontIndex(i) = (frontIndexABS(i) - minValue) / (maxValue - minValue);
    end
end

