function [ output] = aboutdis( data )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
[m,~]=size(data);
output=zeros(m,14);
output(:,1:12)=data;
% output(:,6)=output(:,6)*3.6;
% output(:,12)=output(:,12)*3.6;
output(1,13)=50;
output(1,14)=30;
% output(1,15)=75;
for i=2:1:200
%     output(i,13)=output(i-1,13)+0.2*output(i-1,6)/3.6-0.2*(output(i-1,9)+1)/3.6;
    output(i,13)=output(i-1,13)+loc2dis(output(i-1,4),output(i-1,5),output(i,4),output(i,5))-0.2*(output(i-1,9)+2)/3.6;
    
%     output(i,14)=output(i-1,14)+0.2*output(i-1,9)/3.6-loc2dis(output(i-1,10),output(i-1,11),output(i,10),output(i,11));
    output(i,14)=loc2dis(output(i,4),output(i,5),output(i,10),output(i,11))-output(i,13)-20;
%     output(i,15)=loc2dis(output(i,4),output(i,5),output(i,10),output(i,11))+10;
end
for i=201:1:m
%     output(i,13)=output(i-1,13)+0.2*output(i-1,6)/3.6-0.2*(output(i-1,9)+1)/3.6;
    output(i,13)=output(i-1,13)+loc2dis(output(i-1,4),output(i-1,5),output(i,4),output(i,5))-0.2*(output(i-1,9)+1)/3.6;
    
%     output(i,14)=output(i-1,14)+0.2*output(i-1,9)/3.6-loc2dis(output(i-1,10),output(i-1,11),output(i,10),output(i,11));
    output(i,14)=loc2dis(output(i,4),output(i,5),output(i,10),output(i,11))-output(i,13)-20;
%     output(i,15)=loc2dis(output(i,4),output(i,5),output(i,10),output(i,11))+10;
end
end

