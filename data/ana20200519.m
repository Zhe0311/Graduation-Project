clear;
p=0.8;
num=6:1:21;
num_l=num-1;
AV_num=num_l*p;
ve=10:0.1:30;
PDT_rate=zeros(length(num),length(ve));
ifstable=zeros(length(num),length(ve));
for i=1:1:length(num)
    for j=1:1:length(ve)
        midrate=zeros(50,1);
        for z=1:1:length(midrate)
            label=sign(fix(rand(num_l(i),1)/(1-p)));
            midrate(z)= PDT_length( num(i),label,ve(j) );
        end
        PDT_rate(i,j)=mean(midrate);
    end
end