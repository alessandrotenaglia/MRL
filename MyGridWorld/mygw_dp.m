% ---------------------------------------- %
%  File: mygw_dp.m                         %
%  Date: March 22, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Load/Create MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/MYGW_MDP.mat'], 'file') == 2)
    load([path, '/MYGW_MDP.mat']);
    fprintf("Loaded MYGW_MDP.mat\n");
else
    mygw_mdp;
    fprintf("Created MYGW_MDP.mat\n");
end

%% Policy Iteration
fprintf("Running PI -> ");
% Start timer
tic;
%
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
%
gamma = 0.99;
tol = 1e-6;
VI = ValueIter(mygw.P, mygw.R, gamma, tol);
VI = VI.valueIter();
% Stop timer
toc;

%% Plots PI vs VI
figure()
sgtitle('GridWorld - Dynamic Programming')
% Plot the PI optimal policy
subplot(1, 2, 1)
title('Policy Iteration')
mygw.plotPolicy(PI.policy)
% Plot the VI optimal policy
subplot(1, 2, 2)
title('Value Iteration')
mygw.plotPolicy(VI.policy)

%% Save MyGridWorld
save([path, '/MYGW_DP.mat'], 'PI', 'VI')
