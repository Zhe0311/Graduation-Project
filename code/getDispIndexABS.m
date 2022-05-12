function [dispIndexABS] = getDispIndexABS(label)
    AVNumber = sum(label);   % 自动驾驶车辆数量
    if AVNumber < 2
        dispIndexABS = -1;
        return;
    end
        
    AVLabels = find(label == 1);
    tempSum = 0;
    for j = 1 : 1 : AVNumber-1
        tempSum = tempSum + 1 / (AVLabels(j+1) - AVLabels(j));
    end
    dispIndexABS = tempSum / (AVNumber-1);
end

