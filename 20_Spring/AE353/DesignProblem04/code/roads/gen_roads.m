%% Generate a bunch of roads
clc;
clear all;
close all;

num_roads = 500;

for i = 100:num_roads
    roadfile = sprintf('road_%0.15g.mat', i);
    MakeRoad(roadfile, 'display', false)
end

disp(sprintf('Finished generating %0.15g roads', num_roads));