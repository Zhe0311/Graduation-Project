function plotV(v)
    time = 10;
    v_sample = zeros(1, time+1);
    for i = 1 : 1 : time+1
        v_sample(i) = v(1, (i-1)*100+1);
    end
    for i = 1 : 1 : 1
        plot(0:time, v_sample, 'k');
        hold on;
    end
    xlabel('时间(s)');
    ylabel('速度(m/s)');
end