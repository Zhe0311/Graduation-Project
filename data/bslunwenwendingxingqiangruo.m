v=(0:0.1:32.9)';
%OVM����
v0=33;  % �������ٶ�
k=0.7;  % ����ϵ��
alpha=0.999;  % ����ϵ��
s0=1.62;  % ��С��ȫ����
n=length(v); % ��n�����ٶ�-���롱��
hs=zeros(n,1); % �ȶ�ʱ��ͷ���
%�Զ���ʻ����
% k1=0.45;
% k2=0.25;
k1=10;  % ����ϵ��
k2=10;  % ����ϵ��
deltat=0.01;  % ���Ʋ���
% th=[0.6 1.0 1.4 1.8 2.2];%0.6-2.2
th=0.1:0.1:2.2; % ��ͷʱ��
for i=1:1:n
    hs(i)=s0-v0/alpha*log(1-v(i)/v0);
end
ifstable=zeros(n,1);
p=0:0.01:1;  % �Զ���ʻ����ռ�ȣ�����
% p=0.5;
m=length(p);  % ��m��ʵ�飬ÿ��ʵ��ı��Զ���ʻ����ռ�� p 
stablev=zeros(m,length(th));  % stable v
stablehs1=stablev; 
stablehs2=stablev;
stablethw=stablev;
platoong=zeros(m,n,length(th));
AVg=zeros(n,length(th));
HVg=zeros(n,length(th));
stablep=zeros(length(th),1);
for u=1:1:length(th)
    ifstable=zeros(n,1);
    for i=1:1:m
        for j=1:1:n
            mid=alpha*exp(-1*alpha/v0*(hs(j)-s0));
            if mid<=0.5*k
                ifstable(j)=1;
                vd=alpha*exp(-1*alpha/v0*(hs(j)-s0));
                w=0.01:0.01:30;
                Gm=zeros(length(w),1);
                AVm=zeros(length(w),1);
                HVm=zeros(length(w),1);
                for z=1:1:length(w)
                    mid1=k*vd/sqrt(w(z)^4+(k^2-2*k*vd)*(w(z)^2)+(k*vd)^2);
                    mid2=(sqrt(k1^2+(k2*w(z))^2))/(sqrt((k1-(deltat+k2*th(u))*(w(z)^2))^2+(w(z)*(k2+k1*th(u)))^2));
                    Gm(z)=(mid1^(1-p(i)))*(mid2^p(i));
                    AVm(z)=mid2;
                    HVm(z)=mid1;
                end
                Gmax=max(Gm);
                if Gmax<=1
                   ifstable(j)=1; 
                end
                AVg(j,u)=max(AVm);
                HVg(j,u)=max(HVm);
                platoong(i,j,u)=Gmax;
            else
                vd=alpha*exp(-1*alpha/v0*(hs(j)-s0));
                w=0.01:0.01:30;
                Gm=zeros(length(w),1);
                AVm=zeros(length(w),1);
                HVm=zeros(length(w),1);
                for z=1:1:length(w)
                    mid1=k*vd/sqrt(w(z)^4+(k^2-2*k*vd)*(w(z)^2)+(k*vd)^2);
                    mid2=(sqrt(k1^2+(k2*w(z))^2))/(sqrt((k1-(deltat+k2*th(u))*(w(z)^2))^2+(w(z)*(k2+k1*th(u)))^2));
                    Gm(z)=(mid1^(1-p(i)))*(mid2^p(i));
                    AVm(z)=mid2;
                    HVm(z)=mid1;
                end
                Gmax=max(Gm);
                if Gmax<=1
                   ifstable(j)=1; 
                end
                AVg(j,u)=max(AVm);
                HVg(j,u)=max(HVm);
                platoong(i,j,u)=Gmax;
            end
        end
        stablev(i,u)=v(min(find(ifstable==1)));
        stablehs1(i,u)=hs(min(find(ifstable==1)));
        stablehs2(i,u)=stablev(i,u)*th(u);
        if stablev(i,u)>0
            stablethw(i,u)=stablehs1(i,u)/stablev(i,u);
        end
    end
    if length(find(stablev(:,u)==0))>=1
        stablep(u)=p(min(find(stablev(:,u)==0)));
    else
        stablep(u)=1;
    end
end