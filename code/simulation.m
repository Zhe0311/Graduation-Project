function [ PDTrate, ifstable, GmaxList, stableIndex, crash] = simulation(num, vehiclelabel, veset)
    crash = {false, 0, [], 0}; % {是否发生了碰撞(bool)，发生碰撞的时间(float)，车队排列(list)，追尾的车辆下标(int, 不包含头车) 
    %% 车队参数
    num_l = num - 1;%不包含头车的车辆数目
    delta_t = 0.01;
    t_range = 500;
    t_num = t_range / delta_t;
    x = zeros(num,t_num); %记录每一辆车的车头的位置，以最后一辆车的车尾为0坐标计算
    v = zeros(num,t_num); %记录每一辆车的速度
    a = zeros(num,t_num); %记录每一辆车的加速度
    l = 5*ones(num,1);
    a_des = zeros(num_l,t_num);
    %% 评价指标
    ttc = zeros(num_l, t_num);
    h = zeros(num_l, t_num);
    thw = zeros(num_l, t_num);
    minttc = zeros(num_l, 1);
    minthw = zeros(num_l, 1);
    PDT = zeros(num_l, t_num);
    PDT_AV = zeros(num_l, t_num);
    PDT_HV = zeros(num_l, t_num);
    PDT_HV_HV = zeros(num_l, t_num);
    PDT_HV_AV = zeros(num_l, t_num);
    GmaxList = zeros(num_l, 1);
    PDTrate = -1;
    ifstable = 0;
    stableIndex = -1;
    %AV和HV在车队中的位置
    label=vehiclelabel;
    %初始速度
    ve=veset;
    v(1,1)=ve;
    %% AV跟驰模型参数
    th=0.6;
    k1=0.8;
    k2=0.8;
    kn=0;
    deltat=0.01;
    %% HV跟驰模型参数
    v0 = 33;
    k = 0.7;
    alpha = 0.999;
    s0 = 1.62;
    act = 1.2;
    act_num = act / delta_t;
    %% 扰动初始化
    dis = ve * 0.1;
    a_dis = -2;
    t_dis = dis / abs(a_dis);
    dis_num = t_dis / delta_t + 1;
    a(1, 1:dis_num) = a_dis;
    a(1, (dis_num+1):(2*dis_num)-1) = -a_dis;
    %一阶惯性环节初始化
    tao = 0.05;
    %急减速减速度
    ades = 6.1;

    %% 计算稳定性
    p = sum(label)/num_l;
    hs = s0-v0/alpha*log(1-ve/v0);
    vd = alpha*exp(-1*alpha/v0*(hs-s0));
    
    %% 计算车队传递函数最大增益
    w = 0 : 0.01 : 30;
    norm_HV = zeros(length(w), 1);
    norm_AV = zeros(length(w), 1);
    mid = zeros(length(w), 1);
    for z = 1 : 1 : length(w)
        norm_HV(z) = k*vd / sqrt(w(z)^4+(k^2-2*k*vd)*(w(z)^2)+(k*vd)^2);
        norm_AV(z) = (sqrt(k1^2+(k2*w(z))^2)) / (sqrt((k1-(deltat+k2*th)*(w(z)^2))^2+(w(z)*(k2+k1*th))^2));
        mid(z) = (norm_HV(z))^(1-p) * (norm_AV(z))^p;
    end
    %
    Gmax = max(mid);
    if Gmax <= 1
        ifstable = 1;
    else
        ifstable = 0;
    end

    if ifstable == 0
        stableIndex = Gmax;
    end
    
    %% 计算前1、前2、...前num_l辆车的传递函数最大增益
    mid = zeros(length(w), 1);
    for i = 1 : 1 : num_l
        partOfLabel = label(1:i);
        ratioAV = sum(partOfLabel == 1)/i;
        ratioHV = sum(partOfLabel == 0)/i;
        for z = 1 : 1 : length(w)
            norm_HV(z) = k*vd / sqrt(w(z)^4+(k^2-2*k*vd)*(w(z)^2)+(k*vd)^2);
            norm_AV(z) = (sqrt(k1^2+(k2*w(z))^2)) / (sqrt((k1-(deltat+k2*th)*(w(z)^2))^2+(w(z)*(k2+k1*th))^2));
            mid(z) = (norm_HV(z))^ratioHV * (norm_AV(z))^ratioAV;
        end
        GmaxList(i) = max(mid);
    end

    %% 初始位置
    for i=1:1:num_l
        v(i+1,1)=ve;    
        if label(i)==1
            h(i,1)=th*ve;
        else
            h(i,1)=s0-v0/alpha*log(1-ve/v0);
        end
    end
    for i=num_l:-1:0
        if i==num_l
            x(i+1,1)=sum(l((i+1):end));
        else
            x(i+1,1)=sum(l((i+1):end))+sum(h((i+1):end,1));
        end
    end
    %% 开始遍历一次仿真过程
    for i=2:1:t_num
        %先计算头车的速度，位置
        v(1,i)=v(1,i-1)+a(1,i)*delta_t;
        x(1,i)=x(1,i-1)+v(1,i)*delta_t;
        %再计算后面num_l辆车的目标加速度、加速度、速度、位置
        for j=1:1:num_l
            %先判断车辆类型，车辆类型只影响目标加速度
            if label(j)==1
                a_des(j,i)=max(k1*(h(j,i-1)-th*v(j+1,i-1))+k2*(v(j,i-1)-v(j+1,i-1))+kn*a(j,i-1),-3);
            else
                if i > act_num
                    dav=v0*(1-exp(-1*alpha/v0*(h(j,i-act_num)-s0)));
                    a_des(j,i)=k*(dav-v(j+1,i-act_num));
                else
                    a_des(j,i) = a_des(j,i-1);
                end
            end
            %计算实际加速度
            a(j+1,i)=(tao-delta_t)/tao*a(j+1,i-1)+delta_t/tao*a_des(j,i);
            %计算速度、位置、车间距
            v(j+1,i)=max(v(j+1,i-1)+a(j+1,i)*delta_t,0);
            x(j+1,i)=x(j+1,i-1)+v(j+1,i)*delta_t;

            % 如果发生碰撞，停止实验
            if x(j+1, i) >= x(j, i) - 5
                crash{1} = true;         % 是否发生碰撞
                crash{2} = i * delta_t;  % 发生碰撞的时间
                crash{3} = label;        % 车队排列
                crash{4} = j;            % 发生追尾的车辆下标
                % return
                % error("Crashed!!!!!!!!!!!!");
            end

            h(j,i)=x(j,i)-x(j+1,i)-l(j);
            if label(j)==0
                A=act*v(j+1,i);
            else
                A=deltat*v(j+1,i);
            end
            B=((v(j+1,i))^2)/(2*ades);
            C=((v(j,i))^2)/(2*ades);
            if x(j,i)-x(j+1,i)<A+B-(C-l(j))
                PDT(j,i)=1;
                if label(j) == 1
                    PDT_AV(j, i) = 1;
                else
                    PDT_HV(j, i) = 1;
                    if (j > 1) && (label(j-1) == 1)
                        PDT_HV_AV(j, i) = 1;
                    end
                    if (j > 1) && (label(j-1) == 0)
                        PDT_HV_HV(j, i) = 1;
                    end
                end
            end
        end
    end

    %% 计算评价指标
    for i=2:1:t_num
        for j=1:1:num_l
            thw(j,i)=(x(j,i)-x(j+1,i))/v(j+1,i);
            if v(j+1,i)>v(j,i)
                ttc(j,i)=(x(j,i)-x(j+1,i)-l(j))/(v(j+1,i)-v(j,i));
            end
        end
    end
%     for j = 1 : 1 : num_l
%         minttc(j) = min(ttc(j, find(ttc(j,:)>0)));
%         minthw(j) = min(thw(j, find(thw(j,:)>0)));
%     end
    
    ttcthreshold = 2;
    TET = zeros(num_l, 1);
    TIT = zeros(num_l, 1);
    for i = 2 : 1 : t_num
        for j = 1 : 1 : num_l
            if (ttc(j,i)>0) && (ttc(j,i)<=ttcthreshold)
                TET(j) = TET(j) + 1;
                TIT(j) = TIT(j) + 1/ttc(j,i) -1/ttcthreshold;
            end
        end
    end
    TET = sum(TET * delta_t);
    TIT = sum(TIT * delta_t);
    PDTrate = sum(sum(PDT')) / num_l / t_num;

    %% 如果稳定
    if ifstable
        midv=v(num,:);
        stablev = ve;
        % if min(abs(midv-stablev))<=0.05*stablev
        %     ifstable=2;
        % end
        midv=abs(midv-stablev);
        if size(find(midv<=0.05*stablev))>0
            stablelist=find(midv<=0.05*stablev);
            c1=1;
            arrset=cell(0,0);
            while(c1<numel(stablelist))
            c2=0;
                while(c1+c2+1 <= numel(stablelist)&&stablelist(c1)+c2+1==stablelist(c1+c2+1))
                    c2 = c2 + 1;
                end
                if c2 >= 1
                    arrset = [arrset; (stablelist(c1 : 1 : c1+c2))];
                end
                c1 = c1 + c2 + 1;
            end
            midstablev = arrset{numel(arrset)};
            if midstablev(end) == t_num
                stabletime = midstablev(1) * delta_t;
            else
                stabletime = -1;
            end
        else
            stabletime = -1;
        end
        stableIndex = stabletime;
    end
end