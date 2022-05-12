function [frontIndexABS] = getFrontIndexABS(label)
    AVNumber = sum(label);   % 自动驾驶车辆数量
    number = length(label);  % 车队车辆数（不包括头车）
    if AVNumber == 0
        frontIndexABS = -1;
        return;
    end

        frontIndexABS = sum(find(label == 1)) / (sum(number-AVNumber+1:1:number));
end

