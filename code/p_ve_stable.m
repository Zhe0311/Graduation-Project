p = 0 : 0.1 : 1;
ve = 10 : 1 : 30;

Gmax = zeros(length(p), length(ve));

for i = 1 : 1 : length(p)
    for j = 1 : 1 : length(ve)
        Gmax(i, j) = getStability(p(i), ve(j));
    end
end

surf(ve, p, Gmax);
ylabel('自动驾驶车辆比例');
xlabel('均衡速度(m/s)');
zlabel('G_{max}');