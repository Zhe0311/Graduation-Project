% analysis the relationship between stability and safety

%% parameters about cars
ve = 20;
carNumber = 11;
followingCarNumber = carNumber - 1;
carLabel = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]; % here to define the sequence
%% parameters about simulation
labelNumber = 500;
labelorder = (0 : 1 : followingCarNumber-1);
%% init
ifstable = zeros(labelNumber, length(p));
stabletime=zeros(labelNumber,length(p));
TET = zeros(labelNumber, 4, length(p));
TIT = zeros(labelNumber, 4, length(p));
%% begin simulation
for i = 1 : 1 : length(p)
    for z = 1 : 1 : labelNumber
            [ifstable(z,i),stabletime(z,i)]=stableresult( num,carLabel,ve,0.1 );
            [TET(z,:,i),tit(z,:,i),cfclass(z,:,i)]= safety_ana_cfclass( num,carLabel,ve,0.2,2 );
        end
end