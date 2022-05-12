% ---------------------------------------- %
%  File: maze_dp.m                         %
%  Date: May 12, 2022                      %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% MyGridWorld MDP
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/../Data/MAZE_MDP.mat'], 'file') == 2)
    % Load MyGridWorld MDP
    load([path, '/../Data/MAZE_MDP.mat']);
    fprintf("Loaded MAZE_MDP.mat\n");
else
    % Create MyGridWorld MDP
    maze_mdp;
    fprintf("Created MAZE_MDP\n");
end

%% Policy Iteration
fprintf("Running PI -> ");
% Start timer
tic;
% Create PI
gamma = 0.99;
tol = 1e-6;
PI = PolicyIter(maze.P, maze.R, gamma, tol);
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
VI = ValueIter(maze.P, maze.R, gamma, tol);
VI = VI.valueIter();
% Stop timer
toc;

%% Plots PI vs VI
figure();
sgtitle('GridWorld - Dynamic Programming')
% Plot the PI optimal policy
ax1 = subplot(1, 2, 1);
title('Policy Iteration')
maze.plot(ax1);
maze.plotPolicy(ax1, PI.pi);
% Plot the VI optimal policy
ax2 = subplot(1, 2, 2);
title('Value Iteration')
maze.plot(ax2);
maze.plotPolicy(ax2, VI.pi);

%% Save MyGridWorld
save([path, '/../Data/MAZE_DP.mat'], 'PI', 'VI')
