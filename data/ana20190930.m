load('datac.mat');
load('anatable.mat');
alpha0=[];%known human driver in vehicle II
alpha1=[];%unknown human driver in vehicle II
alpha2=[];%acc in vehicle II
t0=[];%known human driver in vehicle II
t1=[];%unknown human driver in vehicle II
t2=[];%acc in vehicle II
mid=para;
for i=1:1:98
    if analis(i,2)>0
        
        if analis(i,3)<1
            %non acc
            if analis(i,5)<17
            alpha0=[alpha0' (mid(i,1))']';
            t0=[t0' (mid(i,2))']';
            else
                alpha1=[alpha1' (mid(i,1))']';
                t1=[t1' (mid(i,2))']';
            end
        else
            %acc
            alpha2=[alpha2' (mid(i,1))']';
            t2=[t2' (mid(i,2))']';
        end
    end
end
z=zeros(2,3);
mymean=zeros(2,3);
alpha0=alpha0(isfinite(alpha0));
alpha0=alpha0(find(alpha0>0&alpha0<=10));
alpha1=alpha1(isfinite(alpha1));
alpha1=alpha1(find(alpha1>0&alpha1<=10));
alpha2=alpha2(isfinite(alpha2));
alpha2=alpha2(find(alpha2>0&alpha2<=10));
[h,z(1,1)]=ttest2(alpha0,alpha1);
[h,z(1,2)]=ttest2(alpha1,alpha2);
[h,z(1,3)]=ttest2(alpha0,alpha2);

mymean(1,1)=mean(alpha0);
mymean(1,2)=mean(alpha1);
mymean(1,3)=mean(alpha2);
mymean(2,1)=mean(t0);
mymean(2,2)=mean(t1);
mymean(2,3)=mean(t2);