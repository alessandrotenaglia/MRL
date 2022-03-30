% ---------------------------------------- %
%  File: mygw_mdp.m                        %
%  Date: March 22, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Load/Create MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/MYGW.mat'], 'file') == 2)
    load([path, '/MYGW.mat'])
else
    f1_mdp;
end

%% Policy Iteration
% Start timer
tic;
%
gamma = 0.9;
tol = 1e-6;
PI = PolicyIter(mygw.P, mygw.R, gamma, tol);
PI = PI.policyIter();
% Stop timer
toc;

%% Value Iteration
% Start timer
tic;
%
gamma = 0.9;
tol = 1e-6;
VI = ValueIter(mygw.P, mygw.R, gamma, tol);
VI = VI.valueIter();
% Stop timer
toc;

%% Plots PI vs VI
figure()
sgtitle('GridWorld - Dynamic Programming')
% Plot the PI optimal policy
subplot(2, 2, 1)
title('PI - Optimal policy')
mygw.plotPolicy(PI.policy)
% Plot the VI optimal policy
subplot(2, 2, 2)
title('VI - Optimal policy')
mygw.plotPolicy(VI.policy)
% Plot the PI optimal value function
subplot(2, 2, 3)
title('PI - Optimal value function')
mygw.plotValue(PI.value)
% Plot the VI optimal value function
subplot(2, 2, 4)
title('VI - Optimal value function')
mygw.plotValue(VI.value)

%% Save MyGridWorld
save([path, '/MYGW_DP.mat'], 'VI')
