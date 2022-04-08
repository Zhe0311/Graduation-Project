v=(0:0.1:32.9)';
v0=33;
k=0.7;
alpha=0.999;
s0=1.62;
n=length(v);
hs1=zeros(n,1);
k1=0.45;
k2=0.25;
deltat=0.01;
th=0.6;
p=0:0.1:1;
rou=zeros(n,length(p));
f=zeros(n,length(p));
hs2=zeros(n,length(p));
for i=1:1:n
    hs1(i)=s0-v0/alpha*log(1-v(i)/v0)+5;
    
    hs2(i,:)=v(i)*th+5;

end
for j=1:1:length(p)
    for i=1:1:n
        rou(i,j)=1/((1-p(j))*hs1(i)+p(j)*hs2(i,j))*1000;
        f(i,j)=rou(i,j)*v(i)*3.6;
    end
end