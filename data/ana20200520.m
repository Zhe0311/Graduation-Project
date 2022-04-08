% clear;
% %20%渗透率的情况
% p=0.2;
% num=11;
% num_l=num-1;
% ve=10:0.1:30;
% labelnum=10000;
% PDT_rate20=zeros(labelnum,length(ve));
% 
% for j=1:1:length(ve)
%     for z=1:1:labelnum
%         label=sign(fix(rand(num_l,1)/(1-p)));
%         PDT_rate20(z,j)= PDT_length( num,label,ve(j) );
%     end
% end
% save('PDT_rate20.mat','PDT_rate20');
%50%渗透率的情况
% clear;
% p=0.5;
% num=11;
% num_l=num-1;
% ve=10:0.1:30;
% labelnum=10000;
% PDT_rate50=zeros(labelnum,length(ve));
% 
% for j=1:1:length(ve)
%     for z=1:1:labelnum
%         label=sign(fix(rand(num_l,1)/(1-p)));
%         PDT_rate50(z,j)= PDT_length( num,label,ve(j) );
%     end
% end
% save('PDT_rate50.mat','PDT_rate50');
%80%渗透率的情况
clear;
p=0.8;
num=11;
num_l=num-1;
ve=10:0.1:30;
labelnum=10000;
PDT_rate80=zeros(labelnum,length(ve));

for j=1:1:length(ve)
    for z=1:1:labelnum
        label=sign(fix(rand(num_l,1)/(1-p)));
        PDT_rate80(z,j)= PDT_length( num,label,ve(j) );
    end
end
save('PDT_rate80.mat','PDT_rate80');