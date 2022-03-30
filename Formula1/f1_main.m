% ---------------------------------------- %
%  File: mygw_main.m                       %
%  Date: March 11, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Load MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
load([path, '/Monaco.mat'])

%%
nActions = 8;
track = Track(nActions, cells);
% track.plotGrid();

%% Plot an episode
% policy = ones(track.nStates, 1);
% [sts, acts, rews] = track.run(policy, 0.0);
% figure()
% track.plotPolicy(policy);
% track.plotPath(sts);

%% Save MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
save([path, '/F1.mat'], 'track')
