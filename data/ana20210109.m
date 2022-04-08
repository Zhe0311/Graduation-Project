% for i=1:1:98
%     if newa(i)<2
%         newa(i)=newa(i)+1;
%     end
% end
hvt=[];
avt=[];
for i=1:1:98
    if analis(i,3)<1
        hvt=[hvt newa(i)];
    else
        if newa(i)<2
            avt=[avt newa(i)];
        else
            avt=[avt newa(i)-1.5];
        end
    end
end