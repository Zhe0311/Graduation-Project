clear;
v=(0:0.1:32.9)';
v0=33;
k=0.7;
alpha=0.999;
s0=1.62;
nv=length(v);
hs=zeros(nv,1);
tao=1.2;%¿ÉÒÔÐÞ¸Ä
k1=0.45;
k2=0.25;
th=0.6;
% kn=0.8;
kn=0;
delta_t=0.01;
for i=1:1:nv
    hs(i)=s0-v0/alpha*log(1-v(i)/v0);
end
ifstable=zeros(nv,1);
p=0:0.01:1;
m=length(p);
stablev=zeros(m,1);
stablep=0;
for i=1:1:length(p)
    ifstable=zeros(nv,1);
    for j=1:1:nv
        shang1=k*alpha*exp(-1*alpha/v0*(hs(j)-s0));
        w=0.01:0.01:30;
        Gm=zeros(length(w),1);
        for z=1:1:length(w)
            xiashi1=shang1-(w(z)^2)*cos(w(z)*tao);
            xiaxu1=k*w(z)-1*(w(z)^2)*sin(w(z)*tao);
            shangshi2=k1-kn*(w(z)^2);
            shangxu2=k2*w(z);
            xiashi2=k1-(w(z)^2)*cos(delta_t*w(z));
            xiaxu2=(k2+k1*th)*w(z)-(w(z)^2)*sin(delta_t*w(z));
            mid1=(shang1/sqrt(xiashi1^2+xiaxu1^2))^(1-p(i));
            mid2=(sqrt(shangshi2^2+shangxu2^2)/sqrt(xiashi2^2+xiaxu2^2))^p(i);
            Gm(z)=mid1*mid2;
        end
        Gmax=max(Gm);
        if Gmax<=1
            ifstable(j)=1;
        end
    end
    stablev(i)=v(min(find(ifstable==1)));
end