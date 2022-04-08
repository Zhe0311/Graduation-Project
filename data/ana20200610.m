%TTC阈值敏感性分析
clear;
p=[0 0.4 0.8];
num=11;
num_l=num-1;
autonum=floor(num_l*p);
ve=20;
labelnum=1000;
ttcshre=[1 1.5 2 2.5 3];
PDT_rate=zeros(labelnum,length(ttcshre),length(p));
tet=zeros(labelnum,length(ttcshre),length(p));
tit=zeros(labelnum,length(ttcshre),length(p));
for k=1:1:length(p)
    %0代表人工驾驶，1代表自动驾驶    
    for j=1:1:length(ttcshre)
        for z=1:1:labelnum
            mid=randperm(num_l);
            label=zeros(num_l,1);
            label(mid(1:(autonum(k))))=1;
            PDT_rate(z,j,k)= PDT_length( num,label,ve );
            [PDT_rate(z,j,k),~,~,mid1,mid2]= safety_ana( num,label,ve,0.8,ttcshre(j) );
            tet(z,j,k)=sum(mid1);
            tit(z,j,k)=sum(mid2);
        end
    end
end