% ---------------------------------------- %
%  File: f1_track.m                        %
%  Date: March 30, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Load the image
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
RGB = imread([path, '/../Data/Monaco.png']);
figure()
imshow(RGB)

%% Resize the image
RGB = imresize(RGB, [30, 20]);
figure()
imshow(RGB)

%% Convert the image to grey scale
GS = rgb2gray(RGB);
figure()
imshow(GS)

%% Convert the image to black and white
BW = imbinarize(GS);
figure()
imshow(BW)

%% Arrange the image
Monaco = double(BW);
% Starting line
Monaco(4:7, 1) = 2;
% Finisching line
Monaco(16:19, 20) = 3;
% Some fixes
Monaco(30, [1, 20]) = 1;
Monaco(20, 20) = 1;
Monaco = [Monaco(2:end, :); Monaco(1, :)];
figure()
h = heatmap(Monaco);
h.ColorbarVisible = 'off';

%% Save the track image
Monaco = rot90(Monaco, -1);
save([path, '/../Data/Monaco.mat'], 'Monaco');
