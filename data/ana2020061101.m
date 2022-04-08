mostnum=zeros(length(p),length(ve));
meantime=zeros(length(p),length(ve));
for i=1:1:length(p)
    for j=1:1:length(ve)
        mid1=ifstable(:,i,j);
        mid2=stabletime(:,i,j);
        table=tabulate(mid1);
        [~,idx] = max(table(:,2));
        mostnum(i,j)=table(idx);
        table=tabulate(mid2);
        [maxCount,idx] = max(table(:,2));
        meantime(i,j)=table(idx);
%         meantime(i,j)=maxCount;
    end
end
tworange=11*ones(length(ve),1);
onerange=11*ones(length(ve),1);
zerorange=zeros(length(ve),1);
for i=1:1:length(ve)
    if length(find(mostnum(:,i)==2))>0
        tworange(i)=min(find(mostnum(:,i)==2));
    end
    if length(find(mostnum(:,i)==2))>0
        tworange(i)=min(find(mostnum(:,i)==2));
    end
end