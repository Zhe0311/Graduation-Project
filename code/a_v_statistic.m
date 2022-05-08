function statistic(v, a)
    v_all = [];
    a_all = [];
    for i = 1 : 1 : 11
        v_all = [v_all, v(i, 1:2075)];
        a_all = [a_all, a(i, 1:2075)];
    end
    v_sta = tabulate(v_all);
    a_sta = tabulate(a_all);
    v_his = histogram(v_all);
    a_his = histogram(a_all);
end