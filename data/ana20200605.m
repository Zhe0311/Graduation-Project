%PDT与p的关系
clear;
p=0:0.1:1;
num=11;
num_l=num-1;
autonum=floor(num_l*p);
ve=[10 20 30];
labelnum=1000;
PDT_rate=zeros(labelnum,length(ve),length(p));
tet=zeros(labelnum,length(ve),length(p));
tit=zeros(labelnum,length(ve),length(p));
for k=1:1:length(p)
    %0代表人工驾驶，1代表自动驾驶    
    for j=1:1:length(ve)
        for z=1:1:labelnum
            mid=randperm(num_l);
            label=zeros(num_l,1);
            label(mid(1:(autonum(k))))=1;
            PDT_rate(z,j,k)= PDT_length( num,label,ve(j) );
            [PDT_rate(z,j,k),~,~,mid1,mid2]= safety_ana( num,label,ve(j),0.8,2 );
            tet(z,j,k)=sum(mid1);
            tit(z,j,k)=sum(mid2);
        end
    end
end
%PDT与车队长度的关系
% clear;
% p=[0.2 0.6 0.8];
% num=[6 11 16];
% num_l=num-1;
% 
% ve=[10 20];
% labelnum=1000;
% PDT_rate=zeros(labelnum,length(ve),length(num),length(p));
% tet=zeros(labelnum,length(ve),length(num),length(p));
% tit=zeros(labelnum,length(ve),length(num),length(p));
% for k=1:1:length(p)
%     %0代表人工驾驶，1代表自动驾驶
%     for q=1:1:length(num)
%         autonum=floor(num_l(q)*p(k));
%         for j=1:1:length(ve)
%             for z=1:1:labelnum
%                 mid=randperm(num_l(q));
%                 label=zeros(num_l(q),1);
%                 label(mid(1:autonum))=1;
%                 [PDT_rate(z,j,q,k),~,~,mid1,mid2]= safety_ana( num(q),label,ve(j),0.5,2 );
%                 tet(z,j,q,k)=sum(mid1);
%                 tit(z,j,q,k)=sum(mid2);
%             end
%         end
%     end
% end