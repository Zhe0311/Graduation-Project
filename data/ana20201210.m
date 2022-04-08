clc;
clear;
ve=15;
p=0:0.2:0.8;
num=11;
labelnum=500;
num_l=num-1;
autonum=floor(num_l*p);
labelorder=(1:1:num_l)-1;
ifstable=zeros(labelnum,length(p));
stabletime=zeros(labelnum,length(p));
% PDTrate=zeros(num,length(p),length(ve));
% autospace=zeros(num,length(p),length(ve));
tet=zeros(labelnum,4,length(p));
tit=zeros(labelnum,4,length(p));
cfclass=zeros(labelnum,4,length(p));
for i=1:1:length(p)
        for z=1:1:labelnum
            mid=randperm(num_l);
            label=zeros(num_l,1);
            label(mid(1:(autonum(i))))=1;
%             autospace(z,i,j)=sum(labelorder*label);
            [ifstable(z,i),stabletime(z,i)]=stableresult( num,label,ve,0.1 );
            [tet(z,:,i),tit(z,:,i),cfclass(z,:,i)]= safety_ana_cfclass( num,label,ve,0.2,2 );
%             tet(z,i,j)=sum(mid1);
%             tit(z,i,j)=sum(mid2);
    %         titmod(z,i)=sum(1./nonzeros(mid2));
        end
end