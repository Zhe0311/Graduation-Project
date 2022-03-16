clear;
clc;
p = 0 : 0.1 : 1;
ve = 10 : 2 : 30;
th=0.6;
k1=0.8;
k2=0.8;
kn=0;
deltat=0.01;
v0 = 33;
k=0.7;
alpha=0.999;
s0=1.62;
input = zeros(length(ve), length(p));
for i = 1 : 1 : length(ve)
    for j= 1 : 1 : length(p)
        hs=s0-v0/alpha*log(1-ve(i)/v0);
        vd=alpha*exp(-1*alpha/v0*(hs-s0));
        
        w = 0.01:0.01:30;
        Gm = zeros(length(w), 1);
        for z = 1 : 1 : length(w)
            mid1=k*vd/sqrt(w(z)^4+(k^2-2*k*vd)*(w(z)^2)+(k*vd)^2);
            mid2=(sqrt(k1^2+(k2*w(z))^2))/(sqrt((k1-(deltat+k2*th)*(w(z)^2))^2+(w(z)*(k2+k1*th))^2));
            Gm(z)=(mid1^(1-p(j)))*(mid2^p(j));
        end
        disp(max(Gm));
        input(i, j) = max(Gm);
    end
end

%% plot
 surf(p, ve, input);
 xlabel('p');
 ylabel('v_e');
 zlabel('G_{max}');
 