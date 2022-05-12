G_unique = sort(unique(G));

y = zeros(length(G_unique), 1);
for i = 1 : 1 : length(G_unique)
    y(i) = mean(crashindex(G == G_unique(i)));
end

scatter(G, crashindex);
hold on;
scatter(G_unique, y);
legend(["样本", "平均值"])
xlabel("G_{max}");
ylabel("追尾车辆下标(s)");