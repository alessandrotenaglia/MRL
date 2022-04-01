% ---------------------------------------- %
%  File: mygw_main.m                       %
%  Date: March 22, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% My Grid World
nX = 20;
nY = nX;
nActions = 8;
initCell = [1; 1];
termCells = [nX; nY];
obstCells = [];
mygw = MyGridWorld(nX, nY, nActions, initCell, termCells, obstCells);

%% Plot Grid World
% figure();
% mygw.plotGrid();

%% Plot an episode
% policy = ones(mygw.nStates, 1);
% [sts, acts, rews] = mygw.run(0, policy, 0.0);
% figure();
% mygw.plotPolicy(policy);
% mygw.plotPath(sts);

%% Save MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
save([path, '/MYGW.mat'], 'mygw');
