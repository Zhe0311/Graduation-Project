clear;
p=[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
num=11;
num_l=num-1;
disper=[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9];
ve=[10 20 30];
labelnum=1000;
PDT_rate=zeros(labelnum,length(ve),length(disper),length(p));
tet=zeros(labelnum,length(ve),length(disper),length(p));
tit=zeros(labelnum,length(ve),length(disper),length(p));
for k=1:1:length(p)
    %0代表人工驾驶，1代表自动驾驶
    for q=1:1:length(disper)
        autonum=floor(num_l*p(k));
        for j=1:1:length(ve)
            for z=1:1:labelnum
                mid=randperm(num_l);
                label=zeros(num_l,1);
                label(mid(1:autonum))=1;
                [PDT_rate(z,j,q,k),~,~,mid1,mid2]= safety_ana( num,label,ve(j),disper(q),2 );
                tet(z,j,q,k)=sum(mid1);
                tit(z,j,q,k)=sum(mid2);
            end
        end
    end
end