% ---------------------------------------- %
%  File: maze_main.m                       %
%  Date: May 12, 2022                      %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Create the Maze
nX = 15;
nY = 10;
moves = 'kings';
initCells = [1; 1];
termCells = [15; 1];
obstCells = [4*ones(1, 7), 8*ones(1, 7), 12*ones(1, 7);
             1:7, 4:10, 1:7];
maze = MyGridWorld(nX, nY, moves, initCells, termCells, obstCells);
% Plot the Maze
figure(); ax = axes('Parent', gcf);
maze.plot(ax);
maze.plotGrid(ax);

%% Single step
policy = ones(maze.nActions, maze.nStates, 1);
s = 1;
[sp, r] = maze.step(s, policy(s));
% Plot
figure(); ax = axes('Parent', gcf);
maze.plot(ax);
maze.plotPath(ax, [s, sp]);
maze.plotPolicy(ax, policy);

%% Episode
policy = ones(maze.nActions, maze.nStates, 1);
sts = maze.run(0, policy);
% Plot
figure(); ax = axes('Parent', gcf);
maze.plot(ax);
maze.plotPath(ax, sts);
maze.plotPolicy(ax, policy);

%% Save Maze
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
save([path, '/../Data/MAZE.mat'], 'maze');
