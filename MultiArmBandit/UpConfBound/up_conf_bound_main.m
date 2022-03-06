% ---------------------------------------- %
%  File: up_conf_bound_main.m              %
%  Date: February 22, 2022                 %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Stochastic and stationary case
close all;
rng(0);
nArms = 4;
means = (1:nArms)';
stdevs = 2 * ones(nArms, 1);
stat = true;
alphas = 0.0;
nIters = 1e2;
initEst = 5 * ones(nArms, 1);
cs = [0.1; 1; 10];
% Run
up_conf_bound_run(nArms, means, stdevs, stat, alphas, nIters, initEst, cs)

% NOTES:
% Increasing the values of c, also increases the degree of exploration
% Even if the estimate of the means is correct, for c = 10 the excessive 
% eploration involves a lower average reward

%% Stochastic and non-stationary case: constant vs decreasing
close all;
rng(2);
nArms = 4;
means = zeros(nArms, 1);
stdevs = ones(nArms, 1);
stat = false;
nIters = 2e3;
alphas = [0.0; 0.01; 0.1];
initEst = zeros(nArms, 1);
cs = 1;
% Run
up_conf_bound_run(nArms, means, stdevs, stat, alphas, nIters, initEst, cs)

% NOTES:
% Alpha-dec weighs past rewards like recent ones, so the estimates are
% wrong
% Alpha-const weighs recent rewards more, so it has better estimates 
% The mean is a low-pass filter and alpha move the cutoff frequency