% ---------------------------------------- %
%  File: f1_main.m                         %
%  Date: March 30, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Load Monaco track
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
load([path, '/../Data/Monaco.mat']);

%% Create the Grid World
[nX, nY] = size(Monaco);
moves = 'Kings';
[obstCellsX, obstCellsY] = find(Monaco == 1);
[initCellsX, initCellsY] = find(Monaco == 2);
[termCellsX, termCellsY] = find(Monaco == 3);
track = MyGridWorld(nX, nY, moves, ...
    [initCellsX, initCellsY]', ...
    [termCellsX, termCellsY]', ...
    [obstCellsX, obstCellsY]');

%% Plot the track
figure(); ax = axes('Parent', gcf);
track.plot(ax);
track.plotGrid(ax);

%% Plot an episode
% policy = randi(mygw.nActions, mygw.nStates, 1);
policy = 3 * ones(track.nActions, track.nStates, 1);
[sts, acts, rews] = track.run(0, policy);
% Plot
figure(); ax = axes('Parent', gcf);
track.plot(ax);
track.plotPath(ax, sts);
track.plotPolicy(ax, policy);

%% Save MyGridWorld
save([path, '/../Data/F1.mat'], 'track');
