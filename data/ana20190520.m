load('datac.mat');
load('analis.mat');
%% safety indicator: ttc, time headway, Modified Time to Collision, Crash Index, safety margain
ttc0=[];%known human driver in vehicle II
ttc1=[];%unknown human driver in vehicle II
ttc2=[];%acc in vehicle II
th0=[];
th1=[];
th2=[];
mttc0=[];
mttc1=[];
mttc2=[];
ci0=[];
ci1=[];
ci2=[];
sm0=[];
sm1=[];
sm2=[];
for i=1:1:98
    if analis(i,2)>0
        mid=datac{i};
        if analis(i,3)<1
            %non acc
            if analis(i,5)<17
                ttc0=[ttc0' (cal_ttc(mid(:,9),mid(:,12),mid(:,14)))']';
                th0=[th0' (cal_th(mid(:,12),mid(:,14)))']';
                mttc0=[mttc0' (cal_mttc(mid(:,9),mid(:,12),mid(:,14)))']';
                ci0=[ci0' (cal_ci(mid(:,9),mid(:,12),mid(:,14)))']';
                sm0=[sm0' (cal_sm(mid(:,9),mid(:,12),mid(:,14)))']';
            else
                ttc1=[ttc1' (cal_ttc(mid(:,9),mid(:,12),mid(:,14)))']';
                th1=[th1' (cal_th(mid(:,12),mid(:,14)))']';
                mttc1=[mttc1' (cal_mttc(mid(:,9),mid(:,12),mid(:,14)))']';
                ci1=[ci1' (cal_ci(mid(:,9),mid(:,12),mid(:,14)))']';
                sm1=[sm1' (cal_sm(mid(:,9),mid(:,12),mid(:,14)))']';
            end
        else
            %acc
            ttc2=[ttc2' (cal_ttc(mid(:,9),mid(:,12),mid(:,14)))']';
            th2=[th2' (cal_th(mid(:,12),mid(:,14)))']';
            mttc2=[mttc2' (cal_mttc(mid(:,9),mid(:,12),mid(:,14)))']';
            ci2=[ci2' (cal_ci(mid(:,9),mid(:,12),mid(:,14)))']';
            sm2=[sm2' (cal_sm(mid(:,9),mid(:,12),mid(:,14)))']';
        end
    end
end
z=zeros(5,3);
mymean=zeros(5,3);
ttc0=ttc0(find(ttc0>0&ttc0<100));
ttc1=ttc1(find(ttc1>0&ttc1<100));
ttc2=ttc2(find(ttc2>0&ttc2<100));
th0=th0(isfinite(th0));
th0=th0(find(th0>0&th0<=10));
th1=th1(isfinite(th1));
th1=th1(find(th1>0&th1<=10));
th2=th2(isfinite(th2));
th2=th2(find(th2>0&th2<=10));
mttc0=mttc0(find(mttc0>0&mttc0<50));
mttc1=mttc1(find(mttc1>0&mttc1<50));
mttc2=mttc2(find(mttc2>0&mttc2<50));
ci0=ci0(find(ci0>0&ci0<200));
ci1=ci1(find(ci1>0&ci1<200));
ci2=ci2(find(ci2>0&ci2<200));
[h,z(1,1)]=ttest2(ttc0,ttc1);
[h,z(1,2)]=ttest2(ttc1,ttc2);
[h,z(1,3)]=ttest2(ttc0,ttc2);
[h,z(2,1)]=ttest2(th0,th1);
[h,z(2,2)]=ttest2(th1,th2);
[h,z(2,3)]=ttest2(th0,th2);
[h,z(3,1)]=ttest2(mttc0,mttc1);
[h,z(3,2)]=ttest2(mttc1,mttc2);
[h,z(3,3)]=ttest2(mttc0,mttc2);
[h,z(4,1)]=ttest2(ci0,ci1);
[h,z(4,2)]=ttest2(ci1,ci2);
[h,z(4,3)]=ttest2(ci0,ci2);
[h,z(5,1)]=ttest2(sm0,sm1);
[h,z(5,2)]=ttest2(sm1,sm2);
[h,z(5,3)]=ttest2(sm0,sm2);

mymean(1,1)=mean(ttc0);
mymean(1,2)=mean(ttc1);
mymean(1,3)=mean(ttc2);
mymean(2,1)=mean(th0);
mymean(2,2)=mean(th1);
mymean(2,3)=mean(th2);
mymean(3,1)=mean(mttc0);
mymean(3,2)=mean(mttc1);
mymean(3,3)=mean(mttc2);
mymean(4,1)=mean(ci0);
mymean(4,2)=mean(ci1);
mymean(4,3)=mean(ci2);
mymean(5,1)=mean(sm0);
mymean(5,2)=mean(sm1);
mymean(5,3)=mean(sm2);