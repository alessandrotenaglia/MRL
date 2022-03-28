% ---------------------------------------- %
%  File: mygw_mdp.m                        %
%  Date: March 11, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% My Grid World
nX = 5;
nY = 5;
nActions = 8;
termCells = [nX; nY];
obstCells = [2, 2, 3; 2, 3, 2];
mygw = MyGridWorld(nX, nY, nActions, termCells, obstCells);
mygw.plotGrid();

%% MDP
% Generate the transition matrix
mygw = mygw.generateP();
% Generate the reward matrix
mygw = mygw.generateR();

%% Save MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
save([path, '/MYGW_MDP.mat'], 'mygw')
