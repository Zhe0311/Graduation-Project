function playSimulation(position, velocity, label)
% to play the scene of simulation
    [carNumber, time] = size(position);
    spacings = zeros(carNumber, time);
    for i = 2 : 1 : carNumber
        spacings(i, :) = position(i-1, :) - position(i, :);
    end
    figure();
    for i = 1 : 1 : time
        temp = 50;
        pic = ones(160, 5000, 3);
        for j = 1 : 1 : carNumber
            if j > 1
                ifdanger = 0;
                %% 计算危险阈值
                if label(j-1)==0
                    A = 1.2 * velocity(j,i);
                else
                    A = 0.01 * velocity(j,i);
                end
                B = ((velocity(j,i))^2) / (2*6.1);
                C = ((velocity(j-1,i))^2) / (2*6.1);
                %% 判断是否危险
                if spacings(j) < A+B-(C-5)
                    ifdanger = 1;
                end
                %% 画图
                if label(j-1) == 1
                    pic(50:80, floor(temp+10*spacings(j,i)):floor(temp+10*spacings(j,i)+50), 1) = 0;
                    if ifdanger == 1
                        pic(50:80, floor(temp+10*spacings(j,i)):floor(temp+10*spacings(j,i)+25), 2) = 0;
                    end
                else
                    pic(50:80, floor(temp+10*spacings(j,i)):floor(temp+10*spacings(j,i)+50), :) = 0;
                    if ifdanger == 1
                        pic(50:80, floor(temp+10*spacings(j,i)):floor(temp+10*spacings(j,i)+25), 3) = 1;
                    end
                end
            else
                pic(50:80, floor(temp+10*spacings(j,i)):floor(temp+10*spacings(j,i)+50), 2) = 0;
            end
            temp = temp+10*spacings(j,i);
        end
        imshow(pic)
    end
end