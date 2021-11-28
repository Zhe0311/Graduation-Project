function [ifstable, stabilityIndex] = stableEval(v_stable, th, p)
% Input: v_stable: ƽ�⳵��, th: ��ͷʱ��, p: �Զ���ʻ����ռ��
% Output: if the platoon is stable
    %% OVM�������˹���ʻ��
    v0 = 33;  % �������ٶ�
    kappa = 0.7;  % ����ϵ��
    alpha = 0.999;  % ����ϵ��
    s0 = 1.62;  % ��С��ȫ����
    hs = s0 - v0/alpha * log(1 - v_stable/v0); % �ȶ�ʱ��ͷ���
    %% �Զ���ʻ����
    k1 = 10;  % ����ϵ��
    k2 = 10;  % ����ϵ��
    delta_t = 0.01;  % ���Ʋ���
    %% ���㴫�ݺ���ģ��
    for w = 0.01 : 0.01 : 30
        vd = alpha * exp(-1*alpha/v0*(hs-s0));
        HVNorm = kappa * vd / sqrt(w^4+(kappa^2-2*kappa*vd)*(w^2)+(kappa*vd)^2);
        AVNorm = (sqrt(k1^2+(k2*w)^2)) / (sqrt((k1-(delta_t+k2*th)*(w^2))^2+(w*(k2+k1*th))^2));
        GNorm = max((HVNorm^(1-p)) * (AVNorm^p));
    end
    %% �����Ƿ��ȶ��ж�
    if GNorm <= 1
        ifstable = 1; 
    else
        ifstable = 0;
    end
    %% �����ȶ���ָ��
    if ifstable == 1 % ���ȶ��������ȶ���ָ�꣺�ﵽ�ȶ������ʱ��t_stable
 
    else % �����ȶ��������ȶ���ָ�꣺���ݺ�������
        
    end
end

