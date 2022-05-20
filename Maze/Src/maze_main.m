% ---------------------------------------- %
%  File: maze_main.m                       %
%  Date: May 12, 2022                      %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Create the Mazes
nX = 15;
nY = 10;
moves = 'kings';
initCells = [1; 1];
termCells = [15; 1];
% Maze 1
obstCells = [4*ones(1, 7), 8*ones(1, 7), 12*ones(1, 7);
             1:7, 4:10, 1:7];
maze = MyGridWorld(nX, nY, moves, initCells, termCells, obstCells);

%% Plot the Mazes
figure(); ax = axes('Parent', gcf);
maze.plot(ax);
maze.plotGrid(ax);

%% Save Maze
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
save([path, '/../Data/MAZE.mat'], 'maze');
