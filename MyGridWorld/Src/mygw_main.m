% ---------------------------------------- %
%  File: mygw_main.m                       %
%  Date: March 22, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Create the Grid World
nX = 5;
nY = nX;
moves = 'Kings';
initCell = [1; 1];
termCells = [nX; nY];
obstCells = [];
mygw = MyGridWorld(nX, nY, moves, initCell, termCells, obstCells);

%% Plot the Grid World
figure(); ax = axes('Parent', gcf);
mygw.plot(ax);
mygw.plotGrid(ax);

%% Plot a move
s = 1;
policy = zeros(mygw.nStates, 1);
policy(s) = 1;
[sp, r] = mygw.move(s, policy(s));

figure(); ax = axes('Parent', gcf);
mygw.plot(ax);
mygw.plotPath(ax, [s, sp]);
mygw.plotPolicy(ax, policy);

%% Plot an episode
policy = 3 * ones(mygw.nActions, mygw.nStates, 1);
[sts, acts, rews] = mygw.run(0, policy);
% Plot
figure(); ax = axes('Parent', gcf);
mygw.plot(ax);
mygw.plotPath(ax, sts);
mygw.plotPolicy(ax, policy);

%% Save MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
save([path, '/../Data/MYGW.mat'], 'mygw');
