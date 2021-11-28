clear;
clc;
p = 0.5;
th=0.6;
k1=0.8;
k2=0.8;
kn=0;
deltat=0.01;
v0 = 33;
k=0.7;
alpha=0.999;
s0=1.62;
ve = 15;
hs=s0-v0/alpha*log(1-ve/v0);
vd=alpha*exp(-1*alpha/v0*(hs-s0));
w = 0:0.01:30;
Gm=zeros(length(w),1);
mid = zeros(length(w), 1);
mid2 = zeros(length(w), 1);
mid3 = zeros(length(w), 1);
for z = 1 : 1 : length(w)
    mid(z) = k*vd/sqrt(w(z)^4+(k^2-2*k*vd)*(w(z)^2)+(k*vd)^2);
    mid2(z)=(sqrt(k1^2+(k2*w(z))^2))/(sqrt((k1-(deltat+k2*th)*(w(z)^2))^2+(w(z)*(k2+k1*th))^2));
end
maxm = max(mid);
index = find(mid == maxm);
maxm2 = max(mid2);
index2 = find(mid2 == maxm2);
disp(w(index));
disp(w(index2));
disp((maxm^(1-p))*(maxm2^p));

Gm = zeros(length(w), 1);
for z = 1 : 1 : length(w)
    mid1=k*vd/sqrt(w(z)^4+(k^2-2*k*vd)*(w(z)^2)+(k*vd)^2);
    mid2=(sqrt(k1^2+(k2*w(z))^2))/(sqrt((k1-(deltat+k2*th)*(w(z)^2))^2+(w(z)*(k2+k1*th))^2));
    Gm(z)=(mid1^(1-p))*(mid2^p);
end
disp(max(Gm));