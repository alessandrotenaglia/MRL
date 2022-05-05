% ---------------------------------------- %
%  File: wfgw_main.m                        %
%  Date: April 9, 2022                     %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Create the Waterfall Grid World
nX = 7;
nY = 8;
moves = 'kings';
initCells = [1; 5];
termCells = [6; 5];
obstCells = [1:nX; ones(1, nX)];
wind = [0 0 -2 -2 -1 -1 0];
wfgw = WindyGridWorld(nX, nY, moves, initCells, termCells, obstCells, wind);
% Plot the Grid World
figure(); ax = axes('Parent', gcf);
wfgw.plot(ax);
wfgw.plotGrid(ax);

%% Single move
policy = 3*ones(wfgw.nActions, wfgw.nStates, 1);
s = wfgw.initStates;
[sp, r] = wfgw.step(s, policy(s));
% Plot
figure(); ax = axes('Parent', gcf);
wfgw.plot(ax);
wfgw.plotPath(ax, [s, sp]);
wfgw.plotPolicy(ax, policy);

%% Episode
sts = wfgw.run(0, policy);
% Plot
figure(); ax = axes('Parent', gcf);
wfgw.plot(ax);
wfgw.plotPath(ax, sts);
wfgw.plotPolicy(ax, policy);

%% Save MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
save([path, '/../Data/WFGW.mat'], 'wfgw');
