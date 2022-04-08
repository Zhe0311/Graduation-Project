ttc0=[];
ttc1=[];
th0=[];
th1=[];
sm0=[];
sm1=[];
for i=1:1:98
    if anatable(i,2)>0
        mid=datac{i};
        if anatable(i,3)<1
            %non acc
            ttc0=[ttc0' (mid(:,16))']';
            th0=[th0' (mid(:,18))']';
            sm0=[sm0' (mid(:,20))']';
        else
            %acc
            ttc1=[ttc1' (mid(:,16))']';
            th1=[th1' (mid(:,18))']';
            sm1=[sm1' (mid(:,20))']';
        end
    end
end
ttc0=ttc0(find(ttc0>0));
ttc1=ttc1(find(ttc1>0));
th0=th0(isfinite(th0));
th0=th0(find(th0>0));
th1=th1(isfinite(th1));
th1=th1(find(th1>0));
mymean=zeros(2,3);
mymean(1,1)=mean(ttc0);
mymean(1,2)=mean(th0);
mymean(1,3)=mean(sm0);
mymean(2,1)=mean(ttc1);
mymean(2,2)=mean(th1);
mymean(2,3)=mean(sm1);
z=zeros(1,3);
[h,z(1)]=ttest2(ttc0,ttc1);
[h,z(2)]=ttest2(th0,th1);
[h,z(3)]=ttest2(sm0,sm1);

