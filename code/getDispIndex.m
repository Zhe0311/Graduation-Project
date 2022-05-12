function [dispIndex, maxValue, minValue] = getDispIndex(labels)
    AVNumber = sum(labels(1, :));   % �Զ���ʻ��������
    number = length(labels(1, :));  % ���ӳ�������������ͷ����
    [len, ~] = size(labels);
    if AVNumber < 2
        dispIndex = -1;
        return;
    end
    
    dispIndexABS = zeros(len, 1);
    for i = 1 : 1 : len
        AVLabels = find(labels(i, :) == 1);
        tempSum = 0;
        for j = 1 : 1 : AVNumber-1
            tempSum = tempSum + 1 / (AVLabels(j+1) - AVLabels(j));
        end
        dispIndexABS(i) = tempSum / (AVNumber-1);
    end
    
    maxValue = max(dispIndexABS);
    minValue = min(dispIndexABS);
    dispIndex = zeros(len, 1);
    
    for i = 1 : 1 : len
        dispIndex(i) = (dispIndexABS(i) - minValue) / (maxValue - minValue);
    end
end

