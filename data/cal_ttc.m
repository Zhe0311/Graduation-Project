function [ output ] = cal_ttc( t0,t1,d )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
n=length(t0);
output=zeros(n,1);
midt0=t0/3.6;
midt1=t1/3.6;
output=d./(midt1-midt0);
end

