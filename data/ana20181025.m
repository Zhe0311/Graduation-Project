datac=cell(98,1);
for i=1:1:78
    a=num2str(i,'%02d');
    a=['cdata',a,'.mat'];
    mid=importdata(a);
    mid1=mid(:,13)./((mid(:,9)-mid(:,6))/3.6);%ttc
    mid2=mid(:,14)./((mid(:,12)-mid(:,9))/3.6);
    mid3=mid(:,13)./(mid(:,9)/3.6);%th
    mid4=mid(:,14)./(mid(:,12)/3.6);
    mid5=sm(mid(:,6),mid(:,9),mid(:,13));%sm
    mid6=sm(mid(:,9),mid(:,12),mid(:,14));
    datac{i}=[mid mid1 mid2 mid3 mid4 mid5 mid6];
end
for i=80:1:98
    a=num2str(i,'%02d');
    a=['cdata',a,'.mat'];
    mid=importdata(a);
    mid1=mid(:,13)./((mid(:,9)-mid(:,6))/3.6);
    mid2=mid(:,14)./((mid(:,12)-mid(:,9))/3.6);
    mid3=mid(:,13)./(mid(:,9)/3.6);
    mid4=mid(:,14)./(mid(:,12)/3.6);
    mid5=sm(mid(:,6),mid(:,9),mid(:,13));
    mid6=sm(mid(:,9),mid(:,12),mid(:,14));
    datac{i}=[mid mid1 mid2 mid3 mid4 mid5 mid6];
end
