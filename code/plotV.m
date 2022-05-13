function plotV(v)
    
    for i = 1 : 1 : 11
        figure();
        plot(0:0.01:499.99, v(i,:));
        % hold on;
    end
    xlabel('时间(s)');
    ylabel('速度(m/s)');
end