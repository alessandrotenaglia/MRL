% ---------------------------------------- %
%  File: wgw_dp.m                          %
%  Date: April 9, 2022                     %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% MyGridWorld MDP
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/../Data/WGW_MDP.mat'], 'file') == 2)
    % Load MyGridWorld MDP
    load([path, '/../Data/WGW_MDP.mat']);
    fprintf("Loaded WGW_MDP.mat\n");
else
    % Create MyGridWorld MDP
    wgw_mdp;
    fprintf("Created WGW_MDP\n");
end

%% Policy Iteration
fprintf("Running PI -> ");
% Start timer
tic;
% Create PI
gamma = 0.99;
tol = 1e-6;
PI = PolicyIter(wgw.P, wgw.R, gamma, tol);
PI = PI.policyIter();
% Stop timer
toc;

%% Value Iteration
fprintf("Running VI -> ");
% Start timer
tic;
% Create VI
gamma = 0.99;
tol = 1e-6;
VI = ValueIter(wgw.P, wgw.R, gamma, tol);
VI = VI.valueIter();
% Stop timer
toc;

%% Plots PI vs VI
figure();
sgtitle('GridWorld - Dynamic Programming')
% Plot the PI optimal policy
ax1 = subplot(1, 2, 1);
title('Policy Iteration')
wgw.plot(ax1);
wgw.plotPolicy(ax1, PI.pi);
wgw.plotPath(ax1, wgw.run(0, PI.pi));
% Plot the VI optimal policy
ax2 = subplot(1, 2, 2);
title('Value Iteration')
wgw.plot(ax2);
wgw.plotPolicy(ax2, VI.pi);
wgw.plotPath(ax2, wgw.run(0, VI.pi));

%% Save MyGridWorld
save([path, '/../Data/WGW_DP.mat'], 'PI', 'VI')
