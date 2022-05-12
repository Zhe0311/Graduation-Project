function [frontIndexABS] = getFrontIndexABS(label)
    AVNumber = sum(label);   % �Զ���ʻ��������
    number = length(label);  % ���ӳ�������������ͷ����
    if AVNumber == 0
        frontIndexABS = -1;
        return;
    end

        frontIndexABS = sum(find(label == 1)) / (sum(number-AVNumber+1:1:number));
end

