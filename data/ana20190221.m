load('datac.mat');
load('analis.mat');
%% general analysis
th0=[];%known human driver in vehicle II
th1=[];%unknown human driver in vehicle II
th2=[];%acc in vehicle II
sm0=[];
sm1=[];
sm2=[];
for i=1:1:98
    if analis(i,2)>0
        mid=datac{i};
        if analis(i,3)<1
            %non acc
            if analis(i,5)<17
            th0=[th0' (mid(:,18))']';
            sm0=[sm0' (mid(:,20))']';
            else
                th1=[th1' (mid(:,18))']';
                sm1=[sm1' (mid(:,20))']';
            end
        else
            %acc
            th2=[th2' (mid(:,18))']';
            sm2=[sm2' (mid(:,20))']';
        end
    end
end
z=zeros(2,3);
mymean=zeros(2,3);
th0=th0(isfinite(th0));
th0=th0(find(th0>0&th0<=10));
th1=th1(isfinite(th1));
th1=th1(find(th1>0&th1<=10));
th2=th2(isfinite(th2));
th2=th2(find(th2>0&th2<=10));
[h,z(1,1)]=ttest2(th0,th1);
[h,z(1,2)]=ttest2(th1,th2);
[h,z(1,3)]=ttest2(th0,th2);
[h,z(2,1)]=ttest2(sm0,sm1);
[h,z(2,2)]=ttest2(sm1,sm2);
[h,z(2,3)]=ttest2(sm0,sm2);
mymean(1,1)=mean(th0);
mymean(1,2)=mean(th1);
mymean(1,3)=mean(th2);
mymean(2,1)=mean(sm0);
mymean(2,2)=mean(sm1);
mymean(2,3)=mean(sm2);
%% individial analysis
driver_ID=1;  %max:16
THW1=cell(16,1);%non acc
THW2=cell(16,1);%acc
SM1=cell(16,1);
SM2=cell(16,1);
zindividial=zeros(16,2);
mymeanthw=zeros(16,2);
mymeansm=zeros(16,2);
for i=1:1:16
    index=find((analis(:,4)==i)&(analis(:,5)>=17));
    midTHW1=[];
    midTHW2=[];
    midSM1=[];
    midSM2=[];
    n=length(index);
    for j=1:1:n
        mid=datac{index(j)};
        if analis(index(j),2)>0
            if analis(index(j),3)<1
                %non acc
                midTHW1=[midTHW1' (mid(:,18))']';
                midSM1=[midSM1' (mid(:,20))']';
            else
                %acc
                midTHW2=[midTHW2' (mid(:,18))']';
                midSM2=[midSM2' (mid(:,20))']';
            end
        end
    end
    midTHW1=midTHW1(isfinite(midTHW1));
    midTHW1=midTHW1(find(midTHW1>0&midTHW1<=10));
    midTHW2=midTHW2(isfinite(midTHW2));
    midTHW2=midTHW2(find(midTHW2>0&midTHW2<=10));
    THW1{i}=midTHW1;
    THW2{i}=midTHW2;
    SM1{i}=midSM1;
    SM2{i}=midSM2;
    mymeanthw(i,1)=mean(midTHW1);
    mymeanthw(i,2)=mean(midTHW2);
    mymeansm(i,1)=mean(midSM1);
    mymeansm(i,2)=mean(midSM2);
    [h,zindividial(i,1)]=ttest2(midTHW1,midTHW2);
    [h,zindividial(i,2)]=ttest2(midSM1,midSM2);
end
%% results
%results of some driver is very good