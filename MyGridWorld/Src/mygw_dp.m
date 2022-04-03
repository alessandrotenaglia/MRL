% ---------------------------------------- %
%  File: mygw_dp.m                         %
%  Date: March 22, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% MyGridWorld MDP
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/../Data/MYGW_MDP.mat'], 'file') == 2)
    % Load MyGridWorld MDP
    load([path, '/../Data/MYGW_MDP.mat']);
    fprintf("Loaded MYGW_MDP.mat\n");
else
    % Create MyGridWorld MDP
    mygw_mdp;
    fprintf("Created MYGW_MDP.mat\n");
end

%% Policy Iteration
fprintf("Running PI -> ");
% Start timer
tic;
% Create PI
gamma = 0.99;
tol = 1e-6;
PI = PolicyIter(mygw.P, mygw.R, gamma, tol);
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
VI = ValueIter(mygw.P, mygw.R, gamma, tol);
VI = VI.valueIter();
% Stop timer
toc;

%% Plots PI vs VI
figure();
sgtitle('GridWorld - Dynamic Programming')
% Plot the PI optimal policy
ax1 = subplot(1, 2, 1);
title('Policy Iteration')
mygw.plot(ax1);
mygw.plotPolicy(ax1, PI.pi);
% Plot the VI optimal policy
ax2 = subplot(1, 2, 2);
title('Value Iteration')
mygw.plot(ax2);
mygw.plotPolicy(ax2, VI.pi);

%% Save MyGridWorld
save([path, '/../Data/MYGW_DP.mat'], 'PI', 'VI')
