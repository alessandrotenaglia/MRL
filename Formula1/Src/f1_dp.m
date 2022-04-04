% ---------------------------------------- %
%  File: f1_dp.m                           %
%  Date: March 30, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Track
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/../Data/F1_MDP.mat'], 'file') == 2)
    % Load the track
    load([path, '/../Data/F1_MDP.mat']);
    fprintf("Loaded F1_MDP.mat\n");
else
    % Create the track
    f1_mdp;
    fprintf("Created F1_MDP\n");
end

%% Policy Iteration
fprintf("Running PI -> ");
% Start timer
tic;
% Create PI
gamma = 0.9;
tol = 1e-6;
PI = PolicyIter(track.P, track.R, gamma, tol);
PI = PI.policyIter();
% Stop timer
toc;

%% Value Iteration
fprintf("Running VI -> ");
% Start timer
tic;
% Create VI
gamma = 0.9;
tol = 1e-6;
VI = ValueIter(track.P, track.R, gamma, tol);
VI = VI.valueIter();
% Stop timer
toc;

%% Plots PI vs VI
figure();
sgtitle('GridWorld - Dynamic Programming')
% Plot the PI optimal policy
ax1 = subplot(1, 2, 1);
title('Policy Iteration')
track.plot(ax1);
track.plotPolicy(ax1, PI.pi);
% Plot the VI optimal policy
ax2 = subplot(1, 2, 2);
title('Value Iteration')
track.plot(ax2);
track.plotPolicy(ax2, VI.pi);

%% Save MyGridWorld
save([path, '/../Data/F1_DP.mat'], 'PI', 'VI');
