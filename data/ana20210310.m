clc;
clear;
v=2:2:32;
p=0:0.1:1;
tetp=zeros(length(p),100,length(v));
titp=zeros(length(p),100,length(v));
pdtp=zeros(length(p),100,length(v));
plag=zeros(length(p),length(v));
n=11;
num_l=10;
autonum=floor(num_l*p);
HVmaxnum=zeros(length(p),100,length(v));
AVpos=zeros(length(p),100,length(v));
for j=1:1:length(v)
    for i=1:1:length(p)
        plag(i,j)=platoong( v(j),33,0.7,0.999,1.62,0.8,0.8,1.5,0.01,p(i) );
%         for z=1:1:100
%             mid=randperm(num_l);
%             label=zeros(num_l,1);
%             label(mid(1:(autonum(i))))=1;
%             AVpos(i,z,j)=[1 2 3 4 5 6 7 8 9 10]*label;
%             HVmaxnum(i,z,j)=maxHV(label);
%             [ pdtp(i,z,j),~,~,tet,tit ] = safety_result( n,label,v(j),0.05,2,33,0.7,0.999,1.62,0.8,0.8,1.5,0.01 );
%             tetp(i,z,j)=sum(tet);
%             titp(i,z,j)=sum(tit);
%         end
    end
end