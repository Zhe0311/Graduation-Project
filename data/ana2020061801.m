clc;
clear;
ve=25;
p=0.5;
num=11;
labelnum=500;
num_l=num-1;
autonum=floor(num*p);
label=zeros(labelnum,num_l);
ifstable=zeros(labelnum,1);
stabletime=zeros(labelnum,1);
PDTrate=zeros(labelnum,1);
tet=zeros(labelnum,1);
tit=zeros(labelnum,1);
titmod=zeros(labelnum,num_l);
for z=1:1:labelnum
    mid=randperm(num_l);
%     label=zeros(num_l,1);
    label(z,mid(1:autonum))=1;
%         autospace(z,i)=sum(labelorder*label);
    [ifstable(z),stabletime(z)]=stableresult( num,label(z,:),ve,0.1 );
    [PDTrate(z),~,~,mid1,mid2]= safety_ana( num,label(z,:),ve,0.6,2 );
    tet(z)=sum(mid1);
    tit(z)=sum(mid2);
    titmod(z,:)=mid2';
end