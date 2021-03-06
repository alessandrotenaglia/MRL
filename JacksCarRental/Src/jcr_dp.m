% ---------------------------------------- %
%  File: jcr_dp.m                          %
%  Date: March 11, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Load/Create JCR
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/../Data/JCR_MDP.mat'], 'file') == 2)
    load([path, '/../Data/JCR_MDP.mat']);
    fprintf("Loaded JCR_MDP.mat\n");
else
    mygw_mdp;
    fprintf("Created JCR_MDP.mat\n");
end

%% Policy Iteration
% Params
gamma = 0.9;
tol = 1e-6;
PI = PolicyIter(jcr.P, jcr.R, gamma, tol);
PI = PI.policyIter();

%% Value Iteration
% Params
gamma = 0.9;
tol = 1e-6;
VI = ValueIter(jcr.P, jcr.R, gamma, tol);
VI = VI.valueIter();

%% Plots PI vs VI
figure()
sgtitle('JCR - Optimal policy')
% Plot the PI optimal policy
subplot(2, 2, 1)
plotJCR(jcr, PI.pi - jcr.maxMoves - 1, 'PI - Optimal policy')
% Plot the VI optimal policy
subplot(2, 2, 2)
plotJCR(jcr, VI.pi - jcr.maxMoves - 1, 'VI - Optimal policy')
% Plot the PI optimal value function
subplot(2, 2, 3)
plotJCR(jcr, PI.V, 'PI - Optimal value function')
% Plot the VI optimal value function
subplot(2, 2, 4)
plotJCR(jcr, VI.V, 'VI - Optimal value function')

%% Load JCR
save([path, '/../Data/JCR_DP.mat'], 'PI', 'VI')

%% Auxiliary functions
function plotJCR(jcr, z, title)
Z = reshape(z, jcr.maxCars + [1, 1]);
h = heatmap(flipud(Z'));
h.XData = 0 : jcr.maxCars(1);
h.YData = jcr.maxCars(2) : -1 : 0;
h.XLabel = 'Number of cars at loc 1';
h.YLabel = 'Number of cars at loc 2';
h.Colormap = jet;
h.ColorbarVisible = 'off';
h.Title = title;
end
