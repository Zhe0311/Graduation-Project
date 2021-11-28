function [ifstable, stabilityIndex] = stableEval(v_stable, th, p)
% Input: v_stable: 平衡车速, th: 车头时距, p: 自动驾驶车辆占比
% Output: if the platoon is stable
    %% OVM参数（人工驾驶）
    v0 = 33;  % 自由流速度
    kappa = 0.7;  % 敏感系数
    alpha = 0.999;  % 敏感系数
    s0 = 1.62;  % 最小安全距离
    hs = s0 - v0/alpha * log(1 - v_stable/v0); % 稳定时车头间距
    %% 自动驾驶参数
    k1 = 10;  % 控制系数
    k2 = 10;  % 控制系数
    delta_t = 0.01;  % 控制步长
    %% 计算传递函数模长
    for w = 0.01 : 0.01 : 30
        vd = alpha * exp(-1*alpha/v0*(hs-s0));
        HVNorm = kappa * vd / sqrt(w^4+(kappa^2-2*kappa*vd)*(w^2)+(kappa*vd)^2);
        AVNorm = (sqrt(k1^2+(k2*w)^2)) / (sqrt((k1-(delta_t+k2*th)*(w^2))^2+(w*(k2+k1*th))^2));
        GNorm = max((HVNorm^(1-p)) * (AVNorm^p));
    end
    %% 进行是否稳定判断
    if GNorm <= 1
        ifstable = 1; 
    else
        ifstable = 0;
    end
    %% 计算稳定性指标
    if ifstable == 1 % 若稳定，计算稳定性指标：达到稳定所需的时间t_stable
 
    else % 若不稳定，计算稳定性指标：传递函数增益
        
    end
end

