function playSimulation(position)
% to play the scene of simulation
    [carNumber, time] = size(position);
    spacings = zeros(carNumber, time);
    for i = 2 : 1 : carNumber
        spacings(i, :) = position(i-1, :) - position(i, :);
    end
    figure();
    for i = 1 : 1 : time
        temp = 50;
        pic = ones(160, 2500);
        for j = 1 : 1 : carNumber
            pic(50:80, temp+10*spacings(j,i):temp+10*spacings(j,i)+50) = 0;
            temp = temp+10*spacings(j,i);
        end
        imshow(pic)
    end
end