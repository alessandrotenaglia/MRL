% ---------------------------------------- %
%  File: wgw_main.m                        %
%  Date: April 9, 2022                     %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Create the Grid World
nX = 10;
nY = 7;
moves = 'kings';
initCells = [1; 1];
termCells = [nX-2; nY-2];
obstCells = [];
wind = [0 0 0 1 1 1 2 2 1 0];
wgw = WindyGridWorld(nX, nY, moves, initCells, termCells, obstCells, wind);
% Plot the Grid World
figure(); ax = axes('Parent', gcf);
wgw.plot(ax);
wgw.plotGrid(ax);

%% Single move
policy = 3*ones(wgw.nActions, wgw.nStates, 1);
s = 1;
[sp, r] = wgw.step(s, policy(s));
% Plot
figure(); ax = axes('Parent', gcf);
wgw.plot(ax);
wgw.plotPath(ax, [s, sp]);
wgw.plotPolicy(ax, policy);

%% Episode
sts = wgw.run(0, policy);
% Plot
figure(); ax = axes('Parent', gcf);
wgw.plot(ax);
wgw.plotPath(ax, sts);
wgw.plotPolicy(ax, policy);

%% Save MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
save([path, '/../Data/WGW.mat'], 'wgw');
