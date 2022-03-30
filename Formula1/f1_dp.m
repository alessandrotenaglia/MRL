% ---------------------------------------- %
%  File: mygw_mdp.m                        %
%  Date: March 11, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Load MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/F1.mat'], 'file') == 2)
    load([path, '/F1.mat'])
else
    f1_mdp;
end

%% Policy Iteration
% Start timer
tic
%
gamma = 0.9;
tol = 1e-6;
PI = PolicyIter(track.P, track.R, gamma, tol);
PI = PI.policyIter();
% Stop timer
toc

%% Value Iteration
% Start timer
tic
%
gamma = 0.9;
tol = 1e-6;
VI = ValueIter(track.P, track.R, gamma, tol);
VI = VI.valueIter();
% Stop timer
toc

%% Plots PI vs VI
figure()
sgtitle('GridWorld - Dynamic Programming')
% Plot the PI optimal policy
subplot(1, 2, 1)
title('PI - Optimal policy')
track.plotPolicy(VI.policy)
% Plot the VI optimal policy
subplot(1, 2, 2)
title('VI - Optimal policy')
track.plotPolicy(VI.policy)

%% Save MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
save([path, '/F1_DP.mat'], 'VI')
