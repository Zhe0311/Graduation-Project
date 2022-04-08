v=(0:0.1:32.9)';
v0=33;
k=0.7;
alpha=0.999;
s0=1.62;
n=length(v);
hs=zeros(n,1);
for i=1:1:n
    hs(i)=s0-v0/alpha*log(1-v(i)/v0);
end
ifstable=zeros(n,1);
for i=1:1:n
%     den=[1,k,k*alpha*exp(-1*alpha/v0*(hs(i)-s0))];
%     p=roots(den);
%     p1=real(p(1));
%     p2=real(p(2));
%     if p1<0&&p2<0
%         ifstable(i)=1;
%     end
    mid=alpha*exp(-1*alpha/v0*(hs(i)-s0));
    if mid<=0.5*k
        ifstable(i)=1;
    end
end
% for i=1:1:n
%     num=[k*alpha*exp(-1*alpha*(hs(i)-s0)/v0)];
%     den=[1,k,k*alpha*exp(-1*alpha*(hs(i)-s0)/v0)];
%     sys=tf(num,den);
%     ifstable(i)=isstable(sys);
% end