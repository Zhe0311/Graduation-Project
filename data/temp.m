cnt = 0;
for i = 1 : 1 : 98
    data_one = data{i};
    [m, ~] = size(data_one);
    for j = 1 : 1 : m
        if data_one(j, 13) <= 0
            cnt = cnt + 1;
            disp(i);
            disp(j);
        end
    end
end