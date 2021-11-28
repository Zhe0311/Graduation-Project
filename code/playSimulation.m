function playSimulation(position)
% to play the scene of simulation
    [carNumber, time] = size(position);
    spacings = zeros(carNumber, time);
    for i = 2 : 1 : carNumber
        spacings(i, :) = position(i-1, :) - position(i, :);
    end
    figure(1);
    set(gca, 'position', [0.05,0.05,0.9,0.4])
    axis([0 1200 0 20])
    for i = 1 : 1 : carNumber
        rectangle('Position', [50*(i-1)+spacings(i,1), 10, 50, 10], 'LineWidth', 2, 'EdgeColor', 'r');
    end
end

