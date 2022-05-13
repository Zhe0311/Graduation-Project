function temp(v)
dist = [];
for i = 1 : 1 : 11
    dist = [dist; max(max(v(i, :))-20, abs(min(v(i, :))-20))];
end

scatter(0, dist(1), 'rs', 'filled');
hold on;
scatter(1:5, dist(2:6), 'bs', 'filled');
hold on;
scatter(6:10, dist(7:11), 'ks', 'filled');
hold on;
plot(0:10, dist, 'k');
xlabel('车辆下标');
ylabel('最大速度扰动(m/s)');
end