for i = 1 : 1 : 11
    plot(Gmax(i, :), PDT_rate(i, :), 'DisplayName', num2str(0.1*(i-1)));
    hold on;
end
legend