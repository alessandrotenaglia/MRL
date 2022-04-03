% ---------------------------------------- %
%  File: f1_main.m                         %
%  Date: March 30, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Load Monaco track image
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/../Data/Monaco.mat'], 'file') == 2)
    % Load the track
    load([path, '/../Data/Monaco.mat']);
    fprintf("Loaded track image\n");
else
    % Create the track
    f1_track;
    fprintf("Created track image\n");
end

%% Create the Grid World
Monaco = rot90(Monaco, -1);
[nX, nY] = size(Monaco);
moves = 'kings';
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
policy = 3 * ones(track.nActions, track.nStates, 1);
sts = track.run(0, policy);
% Plot
figure(); ax = axes('Parent', gcf);
track.plot(ax);
track.plotPath(ax, sts);
track.plotPolicy(ax, policy);

%% Save the track
save([path, '/../Data/F1.mat'], 'track');
