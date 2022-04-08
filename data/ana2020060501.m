PDTratemean=zeros(length(p),length(ttcshre));
PDTratestd=zeros(length(p),length(ttcshre));
titmean=zeros(length(p),length(ttcshre));
tetmean=zeros(length(p),length(ttcshre));
for i=1:1:length(ttcshre)
    for j=1:1:length(p)
            PDTratemean(j,i)=mean(PDT_rate(:,i,j));
            PDTratestd(j,i)=std(PDT_rate(:,i,j));
            tetmean(j,i)=mean(tet(:,i,j));
            titmean(j,i)=mean(tit(:,i,j));
        
    end
end