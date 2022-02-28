% ---------------------------------------- %
%  File: up_conf_bound_main.m              %
%  Date: 22 February 2022                  %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Deterministic and stationary case
close all;
nArms = 4;
means = (1:nArms)';
stdevs = zeros(nArms, 1);
stat = true;
alphas = 0.0;
nIters = 1000;
initEst = zeros(nArms, 1);
cs = [1; 10; 100];
% Run
up_conf_bound_run(nArms, means, stdevs, stat, alphas, nIters, initEst, cs)

%% Stochastic and stationary case
close all;
nArms = 4;
means = (1:nArms)';
stdevs = ones(nArms, 1);
stat = true;
alphas = [0.0; 0.1];
nIters = 1000;
initEst = zeros(nArms, 1);
cs = [1; 10];
% Run
up_conf_bound_run(nArms, means, stdevs, stat, alphas, nIters, initEst, cs)

%% Stochastic and non-stationary case: constant vs decreasing
close all;
nArms = 4;
means = zeros(nArms, 1);
stdevs = ones(nArms, 1);
stat = false;
nIters = 10000;
alphas = [0.0; 0.1];
initEst = zeros(nArms, 1);
cs = [1; 10];
% Run
up_conf_bound_run(nArms, means, stdevs, stat, alphas, nIters, initEst, cs)
