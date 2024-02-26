clc
clear;
close all

fis = readfis("initial.fis");
theta = 0; 
u = 0.05;
pos = [4 0.4];
final_pos = [10 3.2];

for k = 1 : 100
    dh = sensor_h(pos);
    dv = sensor_v(pos);
    disp(dh)
    disp(dv)
    [dtheta, ~, ~, ~, ~] = evalfis(fis, [dh dv theta]);
    theta = theta + dtheta;
    pos(k+1, :) = pos(k, :) + 10 * u * [cosd( theta ) sind( theta )];
end

disp(pos)