% ---------------------------------------- %
%  File: f1_dp.m                           %
%  Date: March 30, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Load/Create the track
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/F1_MDP.mat'], 'file') == 2)
    load([path, '/F1_MDP.mat'])
else
    f1_mdp;
end

%% Policy Iteration
% Start timer
tic;
%
gamma = 0.9;
tol = 1e-6;
PI = PolicyIter(track.P, track.R, gamma, tol);
PI = PI.policyIter();
% Stop timer
toc;

%% Value Iteration
% Start timer
tic;
%
gamma = 0.9;
tol = 1e-6;
VI = ValueIter(track.P, track.R, gamma, tol);
VI = VI.valueIter();
% Stop timer
toc;

%% Plot PI vs VI
figure();
sgtitle('GridWorld - Dynamic Programming');
% Plot the PI optimal policy
subplot(1, 2, 1);
title('PI - Optimal policy');
track.plotPolicy(PI.policy);
% Plot the VI optimal policy
subplot(1, 2, 2);
title('VI - Optimal policy');
track.plotPolicy(VI.policy);

%% Save MyGridWorld
save([path, '/F1_DP.mat'], 'PI', 'VI');