G_unique = sort(unique(G));

y = zeros(length(G_unique), 1);
for i = 1 : 1 : length(G_unique)
    y(i) = mean(crashtime(G == G_unique(i)));
end

scatter(G, crashtime);
hold on;
plot(G_unique, y);
legend(["", "mean crash time"])
xlabel("传递函数最大增益");
ylabel("第一次碰撞发生的时间(s)");