function statistic(v, a)
    v_all = [];
    a_all = [];
    num = 2909;
    for i = 1 : 1 : 11
        v_all = [v_all, v(i, 1: num)];
        a_all = [a_all, a(i, 1: num)];
    end
    v_sta = tabulate(v_all);
    a_sta = tabulate(a_all);
    figure();
    v_his = histogram(v_all);
    xlabel('速度(m/s)');
    ylabel('频次');
    figure();
    a_his = histogram(a_all);
    xlabel('加速度(m/s^2)');
    ylabel('频次');

    figure();
    for i = 1 : 1 : 11
        plot(1:1:num, a(i, 1:num), 'DisplayName', num2str(i-1));
        hold on;
    end
    xlabel('采样点');
    ylabel('加速度(m/s^2)');
end