function plot_simu(label, v)
    time = 20;
    t = 0.01 : 0.01 : time;
    for i = 1 : 1 : 11
        if i == 1
            plot(t, v(i, 1:time*100), 'r');
            hold on;
        elseif label(i-1) == 1
            plot(t, v(i, 1:time*100), 'b');
            hold on;
        else
            plot(t, v(i, 1:time*100), 'k');
            hold on;
        end
    end
    xlabel('时间(s)');
    ylabel('速度(m/s)');
    legend('头车', '自动驾驶车辆', '人工驾驶车辆');
end