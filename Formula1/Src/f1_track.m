% ---------------------------------------- %
%  File: f1_mdp.m                          %
%  Date: March 30, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Loadtrack image
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
Monaco = imread([path, '/../Data/Monaco.png']);
figure()
imshow(Monaco)

Monaco = imresize(Monaco, [30, 20]);
figure()
imshow(Monaco)

Monaco = double(im2bw(Monaco));
figure()
imshow(Monaco)

Monaco(7, 1:3) = 1;
Monaco(3, 2:7) = 0;
Monaco(2, 8:15) = 0;
Monaco(3, 16:17) = 0;
Monaco(4, 2) = 0;
Monaco(30, 8) = 1;
Monaco(16, 17:20) = 0;
Monaco(20, 20) = 1;
Monaco(26, 8:9) = 0;
Monaco(16:19, 20) = 3;
Monaco(22:23, 4) = 0;
Monaco(6, 8:9) = 1;
Monaco(:, 2) = [];
Monaco(3:6, 1) = 2;
Monaco(2, 6) = 1;
Monaco(3, 7) = 0;

figure()
heatmap(Monaco)
