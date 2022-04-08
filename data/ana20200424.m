v=(0:0.1:32.9)';
v0=33;
k=0.7;
alpha=0.999;
s0=1.62;
nv=length(v);
hs=zeros(nv,1);
tao=(0.01:0.01:2)';
ntao=length(tao);
for i=1:1:nv
    hs(i)=s0-v0/alpha*log(1-v(i)/v0);
end
ifstable=zeros(nv,ntao);
for i=1:1:nv
    for j=1:1:ntao
        shang=k*alpha*exp(-1*alpha/v0*(hs(i)-s0));
        w=0.01:0.01:30;
        Gm=zeros(length(w),1);
        for z=1:1:length(w)
            xiashi=shang-(w(z)^2)*cos(w(z)*tao(j));
            xiaxu=k*w(z)-1*(w(z)^2)*sin(w(z)*tao(j));
            Gm(z)=shang/sqrt(xiashi^2+xiaxu^2);
        end
        Gmax=max(Gm);
        if Gmax<=1
            ifstable(i,j)=1;
        end
    end
end
% figure
% for i=1:1:nv
%     for j=1:1:ntao
%         if ifstable(i,j)==0
%             h1=plot(v(i),tao(j),'r.');
%             hold on;
%         else
%             h2=plot(v(i),tao(j),'b.');
%             hold on;
%         end
%     end
% end
minv=zeros(length(tao),1);
for i=1:1:ntao
    minv(i)=v(min(find(ifstable(:,i)>0)));
end
plot(minv,tao,'r-');
xlabel('v (m/s)');
ylabel('Reaction time (s)');