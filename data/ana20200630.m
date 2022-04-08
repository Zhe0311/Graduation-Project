clc;
clear;
ve=12:3:30;
p=0:0.2:0.8;
num=11;
labelnum=500;
num_l=num-1;
autonum=floor(num_l*p);
labelorder=(1:1:num_l)-1;
% labelorder=2.^labelorder;
% disper=0.1:0.1:0.4;
ifstable=zeros(num,length(p),length(ve));
stabletime=zeros(num,length(p),length(ve));
PDTrate=zeros(num,length(p),length(ve));
autospace=zeros(num,length(p),length(ve));
tet=zeros(num,length(p),length(ve));
tit=zeros(num,length(p),length(ve));
% titmod=zeros(num,length(p));
for i=1:1:length(p)
    for j=1:1:length(ve)
        for z=1:1:labelnum
            mid=randperm(num_l);
            label=zeros(num_l,1);
            label(mid(1:(autonum(i))))=1;
            autospace(z,i,j)=sum(labelorder*label);
            [ifstable(z,i,j),stabletime(z,i,j)]=stableresult( num,label,ve(j),0.1 );
            [PDTrate(z,i,j),~,tet(z,i,j),~,tit(z,i,j),~]= safety_ana_HV( num,label,ve(j),0.6,2 );
%             tet(z,i,j)=sum(mid1);
%             tit(z,i,j)=sum(mid2);
    %         titmod(z,i)=sum(1./nonzeros(mid2));
        end
    end
end