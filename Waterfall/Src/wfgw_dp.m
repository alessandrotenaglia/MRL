% ---------------------------------------- %
%  File: wfgw_dp.m                          %
%  Date: April 9, 2022                     %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% MyGridWorld MDP
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/../Data/WFGW_MDP.mat'], 'file') == 2)
    % Load MyGridWorld MDP
    load([path, '/../Data/WFGW_MDP.mat']);
    fprintf("Loaded WFGW_MDP.mat\n");
else
    % Create MyGridWorld MDP
    wfgw_mdp;
    fprintf("Created WFGW_MDP\n");
end

%% Policy Iteration
fprintf("Running PI -> ");
% Start timer
tic;
% Create PI
gamma = 0.99;
tol = 1e-6;
PI = PolicyIter(wfgw.P, wfgw.R, gamma, tol);
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
VI = ValueIter(wfgw.P, wfgw.R, gamma, tol);
VI = VI.valueIter();
% Stop timer
toc;

%% Plots PI vs VI
figure();
sgtitle('GridWorld - Dynamic Programming')
% Plot the PI optimal policy
ax1 = subplot(1, 2, 1);
title('Policy Iteration')
wfgw.plot(ax1);
wfgw.plotPolicy(ax1, PI.pi);
wfgw.plotPath(ax1, wfgw.run(0, PI.pi));
% Plot the VI optimal policy
ax2 = subplot(1, 2, 2);
title('Value Iteration')
wfgw.plot(ax2);
wfgw.plotPolicy(ax2, VI.pi);
wfgw.plotPath(ax2, wfgw.run(0, VI.pi));

%% Save MyGridWorld
save([path, '/../Data/WFGW_MDP.mat'], 'PI', 'VI')
