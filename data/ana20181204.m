a=zeros(98,1);
deltat=zeros(98,1);
for i=1:1:98
    if analis(i,2)>0
        mid=datac{i};
        [ a(i),deltat(i),rmse ] = linearcarfollowing( mid(:,9),mid(:,12) );
    end
end