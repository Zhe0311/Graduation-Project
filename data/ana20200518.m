clear;
v=(0:0.1:32.9)';
nv=length(v);
k1=0:0.01:1;
k2=0:0.01:1;
% kn=0.8;
kn=0.4;
delta_t=0.01;
th=0.6;
ifstable=zeros(length(k1),length(k2));
for i=1:1:length(k1)
    for j=1:1:length(k2)
        w=0.01:0.01:30;
        Gm=zeros(length(w),1);
        for z=1:1:length(w)
            shangshi2=k1(i)-kn*(w(z)^2);
            shangxu2=k2(j)*w(z);
            xiashi2=k1(i)-(w(z)^2)*cos(delta_t*w(z));
            xiaxu2=(k2(j)+k1(i)*th)*w(z)-(w(z)^2)*sin(delta_t*w(z));
            Gm(z)=sqrt(shangshi2^2+shangxu2^2)/sqrt(xiashi2^2+xiaxu2^2);
        end
        Gmax=max(Gm);
        if Gmax<=1
            ifstable(i,j)=1;
        end
    end
end

