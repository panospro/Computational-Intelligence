clc
clear;
close all

fis = readfis("finalfis.fis");
thetaArray = [0 -45 -90]; 
u = 0.05;
pos = [4 0.4];
final_pos = [10 3.2];

for theta = thetaArray(1,:)
    originalTheta = theta;
    k = 1;
    while pos(k, 1) < 10
        dh = dh_calculate(pos(k,:));
        dv = dv_calculate(pos(k,:));
        [dtheta, ~, ~, ~, ~] = evalfis(fis, [dh theta dv]);

        theta = theta + dtheta;
        pos(k+1, :) = pos(k, :) + u * [cosd( theta ) sind( theta )];
        k = k + 1;
    end
    
    figure();
    hold on;
    axis([0 10.5 0 4]);
    
    % Shaded areas with gray color
    fill([5 5 6 6], [0 1 1 0], [0.8 0.8 0.8]); 
    fill([6 6 7 7], [0 2 2 0], [0.8 0.8 0.8]);
    fill([7 7 10 10], [0 3 3 0], [0.8 0.8 0.8]);
    
    % Plot the current position of the car, update the figure window every 0.1 sec
    for k = 1:size(pos, 1)
        plot(pos(k, 1), pos(k, 2), 'ko', 'MarkerSize', 5, 'MarkerFaceColor', 'b');
        drawnow;
        pause(0.01);
    end
    
    xlabel('x');
    ylabel('y');
    title(sprintf('Real-time Plot with Car Movement, changed fis, with theta = %d', originalTheta));
    hold off;
end
