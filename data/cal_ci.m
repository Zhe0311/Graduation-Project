function [ output ] = cal_ci( v0,v1,d )
%UNTITLED6 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
n=length(v0);
mttc=zeros(n-1,2);
midoutput=zeros(n-1,1);
output=-ones(n-1,1);
midv0=v0/3.6;
midv1=v1/3.6;
a0=(midv0(2:n)-midv0(1:(n-1)))/0.2;
a1=(midv1(2:n)-midv1(1:(n-1)))/0.2;
delta_a=a0-a1;
delta_v=midv0-midv1;
for i=1:1:(n-1)
    if (delta_v(i))^2-2*delta_a(i)*d(i+1)>=0
        mttc(i,1)=(-delta_v(i)+sqrt((delta_v(i))^2-2*delta_a(i)*d(i+1)))/delta_a(i);
        mttc(i,2)=(-delta_v(i)-sqrt((delta_v(i))^2-2*delta_a(i)*d(i+1)))/delta_a(i);
        if max(mttc(i,:))<0
            midoutput(i)=0;
        else
            if min(mttc(i,:))>0
                midoutput(i)=min(mttc(i,:));
            end
            if mttc(i,1)*mttc(i,2)<=0
                midoutput(i)=max(mttc(i,:));
            end
        end
        if midoutput(i)~=0
            output(i)=(-(v0(i+1)+a0(i)*midoutput(i))^2+(v1(i+1)+a1(i)*midoutput(i))^2)/(2*midoutput(i));
        end
    else
        midoutput(i)=0;
    end
end
end

