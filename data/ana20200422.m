%初始条件
num=10+1;%包括头车的车辆数目
num_l=num-1;%不包含头车的车辆数目
delta_t=0.01;
t_range=150;
t_num=t_range/delta_t;
x=zeros(num,t_num);%记录每一辆车的车头的位置，以最后一辆车的车尾为0坐标计算
v=zeros(num,t_num);%记录每一辆车的速度
a=zeros(num,t_num);%记录每一辆车的加速度
l=5*ones(num,1);
a_des=zeros(num_l,t_num);
%评价指标
ttc=zeros(num_l,t_num);
h=zeros(num_l,t_num);
thw=zeros(num_l,t_num);
minttc=zeros(num_l,1);
minthw=zeros(num_l,1);
PDT=zeros(num_l,t_num);
%AV和HV在车队中的位置
label=[1 0 0 0 0 1 0 0 0 0];
%初始速度
ve=28;
v(1,1)=ve;
%CV跟驰参数
th=0.6;
k1=0.8;
k2=0.8;
kn=0;
%kn=
%AV跟驰参数
v0=33;
k=0.7;
alpha=0.999;
s0=1.62;
act=1.2;
act_num=act/delta_t;
%扰动初始化
t_dis=2;
dis=-0.5;
dis_num=t_dis/delta_t;
a(1,1:dis_num)=dis;
% a(1,(dis_num+1):(2*dis_num))=-dis;
%一阶惯性环节初始化
tao=0.05;
%急减速减速度
ades=6.1;
%初始位置
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
%开始遍历一次仿真过程
for i=2:1:t_num
    %先计算头车的速度，位置
    v(1,i)=v(1,i-1)+a(1,i)*delta_t;
    x(1,i)=x(1,i-1)+v(1,i)*delta_t;
    %再计算后面num_l辆车的目标加速度、加速度、速度、位置
    for j=1:1:num_l
        %先判断车辆类型，车辆类型只影响目标加速度
        if label(j)==1
            a_des(j,i)=max(k1*(h(j,i-1)-th*v(j+1,i-1))+k2*(v(j,i-1)-v(j+1,i-1))+kn*a(j,i-1),-3);
%             a_des(j,i)=max(k1*(h(j,i-1)-th*v(j+1,i-1))+k2*(v(j,i-1)-v(j+1,i-1)),-3);
        else
            if i>act_num
%                 dav=v0*(1-exp(-1*alpha/v0*(h(j,i-1)-s0)));
%                 a_des(j,i)=k*(dav-v(j+1,i-1));
                dav=v0*(1-exp(-1*alpha/v0*(h(j,i-act_num)-s0)));
                a_des(j,i)=k*(dav-v(j+1,i-act_num));
            else
                a_des(j,i)=a_des(j,i-1);
            end
        end
        %计算实际加速度
        a(j+1,i)=(tao-delta_t)/tao*a(j+1,i-1)+delta_t/tao*a_des(j,i);
%         a(j+1,i)=a_des(j,i);
        %计算速度、位置、车间距
        v(j+1,i)=max(v(j+1,i-1)+a(j+1,i)*delta_t,0);
        x(j+1,i)=x(j+1,i-1)+v(j+1,i)*delta_t;
        h(j,i)=x(j,i)-x(j+1,i)-l(j);
        A=act*v(j+1,i);
        B=((v(j+1,i))^2)/(2*ades);
        C=((v(j,i))^2)/(2*ades);
        if x(j,i)-x(j+1,i)<A+B-(C-l(j))
            PDT(j,i)=1;
        end
    end
end
%计算评价指标
for i=2:1:t_num
    for j=1:1:num_l
        thw(j,i)=(x(j,i)-x(j+1,i))/v(j+1,i);
        if v(j+1,i)>v(j,i)
            ttc(j,i)=(x(j,i)-x(j+1,i)-l(j))/(v(j+1,i)-v(j,i));
        end
    end
end
for j=1:1:num_l
    minttc(j)=min(ttc(j,find(ttc(j,:)>0)));
    minthw(j)=min(thw(j,find(thw(j,:)>0)));
end