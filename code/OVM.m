%% initial
clear;
clc;

%% parameters
v0 = 33;
k=0.7;
alpha=0.999;
s0=1.62;

%% calculate
h = 1 : 4 : 200;  % h: the distance between two cars
v = 5 : 1 : 35;  % v

v_f = v0 * (1 - exp((-alpha/v0)*(h-s0)));
a = zeros(length(h), length(v));

for i = 1 : 1 : length(h)
    a(i, :) = k * (v_f(i) - v);
end

%% plot
figure();
plot(h, v_f, 'k');
xlabel('车头间距(m)');
ylabel('理想速度(m/s)');

figure();
surf(v, h, a);
xlabel('当前速度(m/s)');
ylabel('车头间距(m)');
zlabel('加速度(m/s^2)');

