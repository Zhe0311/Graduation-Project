%% load the data
clear;
clc;
load('alldriver.mat');
%load('SD_ml.mat');
%% acquire the risky data
index=cell(15,1);
for i=1:1:15
    temp=alldriver{i};
    mid=find(temp(:,1)>=10&(temp(:,4)==0|temp(:,4)>=100)&temp(:,54)>0&temp(:,54)<=2.5&temp(:,55)>0&temp(:,55)<=7);
    index{i}=mid(find(mid>150));
end
num=zeros(15,1);
rangeindex=cell(15,1);
numindex=cell(15,1);
%得到index——满足风险驾驶条件的点的序号(这些点会连续)
%% acquire the risky segment
for i=1:1:15
    temp=index{i};
    n=length(temp);
    m=max(temp);
    if temp(1)==1
        num(i)=0;
        start=1;
    else
        num(i)=0;
        start=temp(1);
    end
    midnumindex=[];
    midrangeindex=[];
    for j=2:1:n
        if temp(j)-temp(j-1)>=5
            num(i)=num(i)+1;
            midnumindex(num(i))=temp(j-1)-start+1;
            midrangeindex(num(i),:)=[start temp(j-1)];
            start=temp(j);
            if j==n
                num(i)=num(i)+1;
                midnumindex(num(i))=1;
                midrangeindex(num(i),:)=[temp(j) temp(j)];
            end
        else
            if j==n
                num(i)=num(i)+1;
                midnumindex(num(i))=temp(j)-start+1;
                midrangeindex(num(i),:)=[start temp(j)];
            else
                continue;
            end
        end
    end
    rangeindex{i}=midrangeindex;
    numindex{i}=midnumindex;
end
%
%% 提取相隔较远的风险片段
portion=zeros(15,1);
modif_rangeindex=cell(15,1);
for i=2:1:15
    temp=rangeindex{i};
    [m,~]=size(temp);
    dif=temp(2:(m-1),1)-temp(1:(m-2),2);
    
    midindex=find(dif>=65);% distance
    modif_rangeindex{i}=temp(midindex,:);
end

for i=2:1:15
    temp=modif_rangeindex{i};
    [m,~]=size(temp);
    for j=1:1:(m-1)
        if temp(j+1,1)-temp(j,2)>=65  %distance
            portion(i)=portion(i)+1;
        end
    end
    portion(i)=portion(i)/(m-1);
end

indexlength=cell(15,1);
alllength=[];
indexgap=cell(15,1);
allgap=[];
for i=2:1:15
    temp=modif_rangeindex{i};
    [m,~]=size(temp);
    mid=zeros(m,1);
    dif=zeros(m,1);
    for j=1:1:m
        mid(j)=temp(j,2)-temp(j,1)+1;
    end
    dif(1)=250;
    dif(2:m)=temp(2:(m),1)-temp(1:(m-1),2);
    indexgap{i}=dif;
    allgap=[allgap' dif']';
    alllength=[alllength' mid']';
    indexlength{i}=mid;
end

%标准化行车数据
num=size(alllength,1);
lengthmean=zeros(15,1);
lengthstd=zeros(15,1);
gapmean=zeros(15,1);
gapstd=zeros(15,1);
for i=2:1:15
    temp=indexlength{i};
    portion(i)=size(temp,1)/num;
    lengthmean(i)=mean(temp);
    lengthstd(i)=std(temp)/sqrt(size(temp,1));
    temp=indexgap{i};
    gapmean(i)=mean(temp);
    gapstd(i)=std(temp)/sqrt(size(temp,1));
end
%% dicision made by drivers after risk
%驾驶员决策行为减速还是不减速flag
%5s内是否存在明显减速度
% speed=cell(15,1);
a=cell(15,1);
mina=cell(15,1);
% riskinfo=cell(15,1);
dectime=cell(15,1);
for i=2:1:15
    data=alldriver{i};
    temp=modif_rangeindex{i};
    [m,~]=size(temp);
    mid1=[data(temp(:,1),1) data(temp(:,1)+24,1)];
%     mid2=[data(temp(:,1),53) data(temp(:,1)+5,53) data(temp(:,1)+10,53) data(temp(:,1)+15,53) data(temp(:,1)+20,53)];
    mid2=zeros(m,25);
    for p=0:5:20
        mid2(:,p/5+1)=data(temp(:,1)+p,53);
    end
    [mid3,mid4]=min(mid2');
%     mid3=(mean(mid2'))';
%     mid4=[data(temp(:,1),1) data(temp(:,1),4)];
%     speed{i}=mid1;
    a{i}=mid2;
    mina{i}=mid3;
    dectime{i}=mid4;
%     riskinfo{i}=mid4;
end
dportion=zeros(15,1);
for i=2:1:15
%     temp=speed{i};
%     midindex=find((temp(:,2)-temp(:,1))<0.05*temp(:,1));
    temp=mina{i};
    midindex=find(temp<=-0.25);
    dportion(i)=length(midindex)/size(temp,2);
end
flag=cell(15,1);%0-dec,1-acc
for i=2:1:15
    temp=(mina{i})';
    mid=ones(size(temp,1),1);
    midindex=find(temp<=-0.25);
%     temp=speed{i};
%     midindex=find((temp(:,2)-temp(:,1))<0.05*temp(:,1));
    mid(midindex)=0;
    dectime{i}(midindex)=100;
    flag{i}=mid;
end
%% 提取HbO数据和vehicle信息
%对每个片段，取其前面一段的HbO的平均当作baseline
%相对baseline归一化，相对baseline变化的百分比
datanum=length(alllength);
j=0;
allflag=zeros(datanum,1);
datarange=zeros(datanum,2);
basicinfo=zeros(datanum,6);% 6=driver No.+flag+length+gap+begin+end; flag:0-dec,1-acc
for i=2:1:15
    midnum=size(flag{i},1);
    allflag((j+1):(j+midnum))=flag{i};
    basicinfo((j+1):(j+midnum),1)=i;
    datarange((j+1):(j+midnum),:)=modif_rangeindex{i};
    j=j+midnum;
end
basicinfo(:,2)=allflag;
basicinfo(:,3)=alllength;
basicinfo(:,4)=allgap;
basicinfo(:,5:6)=datarange;
HbOfeature=cell(24,1);
vehicleinfo=cell(24,1);
time=-13:1:16;
hdetrend=cell(datanum,1);
baseline=zeros(datanum,24);
allriskdata=cell(24,1);
for i=1:1:datanum
    driverno=basicinfo(i,1);
    temp=alldriver{driverno};
    index1=basicinfo(i,5)-115;
    index2=basicinfo(i,5)-65;
    index3=basicinfo(i,5)+50;
    midhdetrend=zeros(index3-index1+1+4,24);
    for p=1:1:24
        midhdetrend(:,p)=detrend(temp(index1:(index3+4),p+4));
    end
    hdetrend{i}=midhdetrend;
%     baseline(i,:)=mean(temp(index1:index2,5:28));
    baseline(i,:)=mean(midhdetrend(40:91,:));
end
for i=1:1:24
    midHbO=zeros(datanum,24);
    midvehicle=zeros(datanum,4);
    for j=1:1:datanum
        driverno=basicinfo(j,1);
%         temp=alldriver{driverno};
        temp=hdetrend{j};
%         index1=basicinfo(j,5)+5*(i-14);
        index1=116+5*(i-14);
        index2=index1+4;
        midHbO(j,:)=(mean(temp(index1:index2,:))-baseline(j,:))./baseline(j,:);
        strangeindex1=find(midHbO(j,:)>=10);
        strangeindex2=find(midHbO(j,:)<=-10);
        midHbO(j,strangeindex1)=10;
        midHbO(j,strangeindex2)=-10;
        midvehicle(j,1)=mean(temp(index1:index2,1));
        midvehicle(j,2)=min(mean(temp(index1:index2,4)),8000);
        midvehicle(j,3)=max(temp(index2,1)-temp(index1,1),-5);
        midvehicle(j,4)=temp(index2,4)-temp(index1,4);
        if midvehicle(j,4)>=400
            midvehicle(j,4)=400;
        end
        if midvehicle(j,4)<=-400
            midvehicle(j,4)=-400;
        end
    end
    % 0-1
%     tempmin1=min(midHbO);
%     tempp1=max(midHbO)-min(midHbO);
%     tempmin2=min(midvehicle);
%     tempp2=max(midvehicle)-min(midvehicle);
%     for j=1:1:datanum
%         midHbO(j,:)=(midHbO(j,:)-tempmin1)./tempp1;
%         midvehicle(j,:)=(midvehicle(j,:)-tempmin2)./tempp2;
%     end
    HbOfeature{i}=midHbO;
    vehicleinfo{i}=midvehicle;
    allriskdata{i}=[basicinfo midvehicle midHbO];
end
%% 训练分类器
%十折交叉验证
%svm之前要进行归一化到0-1之间
%以驾驶员是否减速为label，进行训练
k=10;
ttestnum=floor(0.1*datanum);
ranindex=randperm(datanum);
ttrain=ranindex(1:(datanum-ttestnum));
ttest=ranindex((datanum-ttestnum):datanum);
ttraindata=cell(24,1);
ttestdata=cell(24,1);
for i=1:1:24
    temp=allriskdata{i};
    ttraindata{i}=temp(ttrain,:);
    ttestdata{i}=temp(ttest,:);
end
decnum=find((ttraindata{1}(:,2))==0);% 807 805
accnum=find((ttraindata{1}(:,2))==1);% 520 693
mnum=length(decnum) + length(accnum);%500+500
decr=randperm(length(decnum));
%decindex=decr(1:600);
decindex=decnum(decr);
accr=randperm(length(accnum));
%accindex=accr(1:600);
accindex=accnum(accr);
for i=1:1:24
    temp=ttraindata{i};
    ttraindata{i}=temp([decindex' accindex']',:);
end
ranindex=randperm(mnum/2);
mid=floor(mnum/k/2);
trainindex=zeros(2*(k-1)*mid,k);
testindex=zeros(2*mid,k);
trainindex(:,1)=[(ranindex(1:((k-1)*mid))) (ranindex(1:((k-1)*mid)))+k*mid]';
testindex(:,1)=[(ranindex(((k-1)*mid+1):(k*mid))) (ranindex(((k-1)*mid+1):(k*mid)))+2*mid]';
trainindex(:,k)=[(ranindex((mid+1):(k*mid))) (ranindex((mid+1):(k*mid)))+k*mid]';
testindex(:,k)=[(ranindex((1):(mid))) (ranindex((1):(mid)))+2*mid]';
for i=2:1:(k-1)
    trainindex(:,i)=[ranindex(1:((k-i)*mid)) ranindex(((k+1-i)*mid+1):(k*mid)) ranindex(1:((k-i)*mid))+k*mid ranindex(((k+1-i)*mid+1):(k*mid))+k*mid]';
    testindex(:,i)=[(ranindex(((k-i)*mid+1):((k+1-i)*mid))) (ranindex(((k-i)*mid+1):((k+1-i)*mid)))+2*mid]';
end
classrate=cell(24,1);
classratec=cell(24,1);
indirate=cell(15,1);
for i=2:1:15
    indirate{i}=zeros(24,k,6);
end
for i=1:1:24
    mid=zeros(k,6);
    midd=zeros(k,3);
    temp=ttraindata{i};
    temptest=ttestdata{i};
    for j=1:1:k
        mid1=temp(trainindex(:,j),7:10);
        mid11=temp(testindex(:,j),7:10);
        mid2=temp(trainindex(:,j),11:34);
        mid22=temp(testindex(:,j),11:34);
        mid3=temp(trainindex(:,j),7:34);
        mid33=temp(testindex(:,j),7:34);
        mid44=temptest(:,7:10);
        mid55=temptest(:,11:34);
        flag1=temp(trainindex(:,j),2);
        flag11=temp(testindex(:,j),2);
        flagg1=temptest(:,2);
        driverno1=temp(trainindex(:,j),1);
        driverno11=temp(testindex(:,j),1);
        %0-1
        for p=1:1:1080
            anyindex1=find(mid2(p,:)>=10);
            anyindex2=find(mid2(p,:)<=-10);
            mid2(p,anyindex1)=10;
            mid2(p,anyindex2)=-10;
            anyindex1=find(mid3(p,5:28)>=10);
            anyindex2=find(mid3(p,5:28)<=-10);
            mid3(p,anyindex1+4)=10;
            mid3(p,anyindex2+4)=-10;
        end
        for p=1:1:120
            anyindex1=find(mid22(p,:)>=10);
            anyindex2=find(mid22(p,:)<=-10);
            mid22(p,anyindex1)=10;
            mid22(p,anyindex2)=-10;
            anyindex1=find(mid33(p,5:28)>=10);
            anyindex2=find(mid33(p,5:28)<=-10);
            mid33(p,anyindex1+4)=10;
            mid33(p,anyindex2+4)=-10;
        end
        for p=1:1:164
            anyindex1=find(mid55(p,:)>=10);
            anyindex2=find(mid55(p,:)<=-10);
            mid55(p,anyindex1)=10;
            mid55(p,anyindex2)=-10;
        end
        
        %归一化投入svm中
        min1=min(mid1);
        min11=min(mid11);
        dis1=max(mid1)-min(mid1);
        dis11=max(mid11)-min(mid11);
        min2=min(mid2);
        min22=min(mid22);
        dis2=max(mid2)-min(mid2);
        dis22=max(mid22)-min(mid22);
        min3=min(mid3);
        min33=min(mid33);
        dis3=max(mid3)-min(mid3);
        dis33=max(mid33)-min(mid33);
        min44=min(mid44);
        dis44=max(mid44)-min(mid44);
        min55=min(mid55);
        dis55=max(mid55)-min(mid55);
        for p=1:1:1080
            mid1(p,:)=(mid1(p,:)-min1)./dis1;
            mid2(p,:)=(mid2(p,:)-min2)./dis2;
            mid3(p,:)=(mid3(p,:)-min3)./dis3;
        end
        for p=1:1:120
            mid11(p,:)=(mid11(p,:)-min11)./dis11;
            mid22(p,:)=(mid22(p,:)-min22)./dis22;
            mid33(p,:)=(mid33(p,:)-min33)./dis33;
        end
        for p=1:1:164
            mid44(p,:)=(mid44(p,:)-min44)./dis44;
            mid55(p,:)=(mid55(p,:)-min55)./dis55;
        end
        % vehicle info
        svmModel1=svmtrain(mid1,flag1,'kernel_function','quadratic');
        class1=svmclassify(svmModel1,mid1);
        class11=svmclassify(svmModel1,mid11);
        classs1=svmclassify(svmModel1,mid44);
        mid(j,1)=length(find((class1-flag1)==0))/length(trainindex(:,j));
        mid(j,2)=length(find((class11-flag11)==0))/length(testindex(:,j));
        midd(j,1)=length(find((classs1-flagg1)==0))/size(temptest,1);
        for no=2:1:15
            indiflag=flag1(find(driverno1==no));
            indiflagg=flag11(find(driverno11==no));
            indiclass=class1(find(driverno1==no));
            indiclasss=class11(find(driverno11==no));
            indirate{no}(i,j,1)=length(find((indiflag-indiclass)==0))/length(indiflag);
            indirate{no}(i,j,2)=length(find((indiflagg-indiclasss)==0))/length(indiflagg);
        end
        % HbO
        svmModel2=svmtrain(mid2,flag1,'kernel_function','quadratic');
        class2=svmclassify(svmModel2,mid2);
        class22=svmclassify(svmModel2,mid22);
        classs2=svmclassify(svmModel2,mid55);
        mid(j,3)=length(find((class2-flag1)==0))/length(trainindex(:,j));
        mid(j,4)=length(find((class22-flag11)==0))/length(testindex(:,j));
        midd(j,2)=length(find((classs2-flagg1)==0))/size(temptest,1);
        for no=2:1:15
            indiflag=flag1(find(driverno1==no));
            indiflagg=flag11(find(driverno11==no));
            indiclass=class2(find(driverno1==no));
            indiclasss=class22(find(driverno11==no));
            indirate{no}(i,j,3)=length(find((indiflag-indiclass)==0))/length(indiflag);
            indirate{no}(i,j,4)=length(find((indiflagg-indiclasss)==0))/length(indiflagg);
        end
        % both
%         svmModel3=svmtrain(mid3,flag1,'kernel_function','rbf');
%         class3=svmclassify(svmModel3,mid3);
%         class33=svmclassify(svmModel3,mid33);
%         classs3=svmclassify(svmModel3,temptest(:,7:34));
%         mid(j,5)=length(find((class3-flag1)==0))/length(trainindex(:,j));
%         mid(j,6)=length(find((class33-flag11)==0))/length(testindex(:,j));
%         midd(j,3)=length(find((classs3-flagg1)==0))/size(temptest,1);
%         for no=1:1:15
%             indiflag=flag1(find(driverno1==no));
%             indiflagg=flag11(find(driverno11==no));
%             indiclass=class3(find(driverno1==no));
%             indiclasss=class33(find(driverno11==no));
%             indirate{no}(i,j,5)=length(find((indiflag-indiclass)==0))/length(indiflag);
%             indirate{no}(i,j,6)=length(find((indiflagg-indiclasss)==0))/length(indiflagg);
%         end
    end
    classrate{i}=mid;
    classratec{i}=midd;
end
%% plot the classrate
classratemean=zeros(24,6);
classratestd=zeros(24,6);
classratecmean=zeros(24,3);
classratecstd=zeros(24,3);
for i=1:1:24
    temp=classrate{i};
    tempp=classratec{i};
    classratemean(i,:)=mean(temp);
    classratecmean(i,:)=mean(tempp);
    classratestd(i,:)=std(temp)/sqrt(k);
    classratecstd(i,:)=std(tempp)/sqrt(k);
end
figure
hold on;
% h1=errorbar(-13:1:10,classratemean(1:24,2),classratestd(1:24,2),'ro-');
h2=errorbar(-7:1:3,classratemean(7:17,4),classratestd(7:17,4),'bo-');
% h3=errorbar(-13:1:10,classratemean(1:24,6),classratestd(1:24,6),'go-');
% legend([h1 h2 h3],'Vehicle Info','HbO','Both');
title('Classification Accuracy Based on HbO Info');
xlabel('Time/s');
ylabel('Accuracy');
axis([-7 3 0.4 1]);
%% plot the indirate
i1=3;
i2=11;
i3=13;
indimean=zeros(24,6);
indistd=zeros(24,6);
for i=1:1:24
    temp=indirate{i1};
    indimean(i,1)=mean(reshape(temp(i,:,3),10,1));
    indistd(i,1)=std(reshape(temp(i,:,3),10,1))/sqrt(k);
    indimean(i,2)=mean(reshape(temp(i,:,4),10,1));
    indistd(i,2)=std(reshape(temp(i,:,4),10,1))/sqrt(k);
    temp=indirate{i2};
    indimean(i,3)=mean(reshape(temp(i,:,3),10,1));
    indistd(i,3)=std(reshape(temp(i,:,3),10,1))/sqrt(k);
    indimean(i,4)=mean(reshape(temp(i,:,4),10,1));
    indistd(i,4)=std(reshape(temp(i,:,4),10,1))/sqrt(k);
    temp=indirate{i3};
    indimean(i,5)=mean(reshape(temp(i,:,3),10,1));
    indistd(i,5)=std(reshape(temp(i,:,3),10,1))/sqrt(k);
    indimean(i,6)=mean(reshape(temp(i,:,4),10,1));
    indistd(i,6)=std(reshape(temp(i,:,4),10,1))/sqrt(k);
end
figure
hold on;
h1=plot(-7:1:3,indimean(7:17,2),'ro-');
h2=plot(-7:1:3,indimean(7:17,4),'bo-');
h3=plot(-7:1:3,indimean(7:17,6),'go-');
legend([h1 h2 h3],'Driver No#03','Driver No#11','Driver No#13');
xlabel('Time/s');
ylabel('Accuracy');
axis([-7 3 0 1]);
title('Individual Classification Accuracy Based on HbO Info');