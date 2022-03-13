% ---------------------------------------- %
%  File: JCR.m                             %
%  Date: March 11, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Load
load JCR.mat

%% Policy Iteration
% Start timer
tic
%
gamma = 0.9;
tol = 1e-6;
PI = PolicyIter(jcr.P, jcr.R, gamma, tol);
PI = PI.policyIter();
% Stop timer
toc

%% Value Iteration
% Start timer
tic
%
gamma = 0.9;
tol = 1e-6;
VI = ValueIter(jcr.P, jcr.R, gamma, tol);
VI = VI.valueIter();
% Stop timer
toc

%% Plots PI vs VI
x = 0:jcr.maxCars(1);
y = 0:jcr.maxCars(2);
[X, Y] = meshgrid(x, y);

figure()
sgtitle('JCR - Optimal policy')
%
subplot(1, 2, 1)
title('Polcy Iteration')
axis equal; hold on;
Z = reshape(PI.policy - jcr.maxMoves - 1, jcr.maxCars + [1, 1]);
colorbar;
contourf(X, Y, Z, jcr.nActions)
xlabel('# cars at 1');
ylabel('# cars at 2');
%
subplot(1, 2, 2)
title('Value Iteration')
axis equal; hold on;
Z = reshape(VI.policy - jcr.maxMoves - 1, jcr.maxCars + [1, 1]);
colorbar;
contourf(X, Y, Z, jcr.nActions)
xlabel('# cars at 1');
ylabel('# cars at 2');
