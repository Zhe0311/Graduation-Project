function Gmax = getStability(p, ve)

    %% parameters
    % AV跟驰模型参数
    th=0.6;
    k1=0.8;
    k2=0.8;
    % HV跟驰模型参数
    v0 = 33;
    k = 0.7;
    alpha = 0.999;
    s0 = 1.62;
   
    hs = s0-v0/alpha*log(1-ve/v0);
    vd = alpha*exp(-1*alpha/v0*(hs-s0));

    w = 0.01 : 0.01 : 30;
    norm_HV = zeros(length(w), 1);
    norm_AV = zeros(length(w), 1);
    mid = zeros(length(w), 1);
    for z = 1 : 1 : length(w)
        norm_HV(z) = k*vd / sqrt(w(z)^4+(k^2-2*k*vd)*(w(z)^2)+(k*vd)^2);
        norm_AV(z) = (sqrt(k1^2+(k2*w(z))^2)) / (sqrt(((k1-(0.01+k2*th)^2*w(z)^2)^2) + (w(z)*(k2+k1*th))^2));
        mid(z) = (norm_HV(z))^(1-p) * (norm_AV(z))^p;
    end
    
    Gmax = max(mid);
end
%(0.01+k2*th)^2*