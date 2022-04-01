% ---------------------------------------- %
%  File: f1_main.m                         %
%  Date: March 30, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Load track
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
load([path, '/Monaco.mat']);

%% Generate the track
nActions = 8;
track = Track(nActions, cells);

%% Plot the track
% figure();
% track.plotGrid();

%% Plot an episode
% policy = ones(track.nStates, 1);
% [sts, acts, rews] = track.run(0, policy, 0.0);
% figure()
% track.plotPolicy(policy);
% track.plotPath(sts);

%% Save MyGridWorld
save([path, '/F1.mat'], 'track');
