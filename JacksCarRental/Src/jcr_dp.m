% ---------------------------------------- %
%  File: jcr_dp.m                          %
%  Date: March 11, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Load JCR
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
load([path, '/JCR.mat'])

%% Policy Iteration
% Start timer
tic
% Params
gamma = 0.9;
tol = 1e-6;
PI = PolicyIter(jcr.P, jcr.R, gamma, tol);
PI = PI.policyIter();
% Stop timer
toc

%% Value Iteration
% Start timer
tic
% Params
gamma = 0.9;
tol = 1e-6;
VI = ValueIter(jcr.P, jcr.R, gamma, tol);
VI = VI.valueIter();
% Stop timer
toc

%% Plots PI vs VI
cars1 = 0:jcr.maxCars(1);
cars2 = fliplr(0:jcr.maxCars(2));
figure()
sgtitle('JCR - Optimal policy')
% Plot the PI optimal policy
subplot(2, 2, 1)
Z = reshape(PI.policy - jcr.maxMoves - 1, jcr.maxCars + [1, 1]);
h = heatmap(flipud(Z));
h.XData = cars1;
h.YData = cars2;
h.XLabel = 'Number of cars at loc 1';
h.YLabel = 'Number of cars at loc 2';
h.Colormap = jet;
h.Title = 'PI - Optimal policy';
% Plot the VI optimal policy
subplot(2, 2, 2)
Z = reshape(VI.policy - jcr.maxMoves - 1, jcr.maxCars + [1, 1]);
h = heatmap(flipud(Z));
h.XData = cars1;
h.YData = cars2;
h.XLabel = 'Number of cars at loc 1';
h.YLabel = 'Number of cars at loc 2';
h.Colormap = jet;
h.Title = 'VI - Optimal policy';
% Plot the PI optimal value function
subplot(2, 2, 3)
Z = reshape(PI.value - jcr.maxMoves - 1, jcr.maxCars + [1, 1]);
h = heatmap(flipud(Z));
h.XData = cars1;
h.YData = cars2;
h.XLabel = 'Number of cars at loc 1';
h.YLabel = 'Number of cars at loc 2';
h.Colormap = jet;
h.Title = 'PI - Optimal value function';
% Plot the VI optimal value function
subplot(2, 2, 4)
Z = reshape(VI.value - jcr.maxMoves - 1, jcr.maxCars + [1, 1]);
h = heatmap(flipud(Z));
h.XData = cars1;
h.YData = cars2;
h.XLabel = 'Number of cars at loc 1';
h.YLabel = 'Number of cars at loc 2';
h.Colormap = jet;
h.Title = 'VI - Optimal value function';
