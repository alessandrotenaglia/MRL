% ---------------------------------------- %
%  File: eps_greedy_main.m                 %
%  Date: 22 February 2022                  %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Deterministic and stationary case: constant vs decreasing eps
close all;
nArms = 4;
means = (1:nArms)';
stdevs = zeros(nArms, 1);
stat = true;
alphas = 0.0;
nIters = 200;
initEst = zeros(nArms, 1);
epsilons = [0.1; 0.1];
epsconst = [true; false];
% Run
eps_greedy_run(nArms, means, stdevs, stat, alphas, nIters, initEst, ...
    epsilons, epsconst)

%% Deterministic and stationary case: optimistic initialization
close all;
nArms = 4;
means = (1:nArms)';
stdevs = zeros(nArms, 1);
stat = true;
alphas = 0.0;
nIters = 200;
initEst = 5 * ones(nArms, 1);
epsilons = 0.1;
epsconst = false;
% Run
eps_greedy_run(nArms, means, stdevs, stat, alphas, nIters, initEst, ...
    epsilons, epsconst)

%% Stochastic and stationary case: constant vs decreasing alpha
close all;
nArms = 4;
means = (1:nArms)';
stdevs = ones(nArms, 1);
stat = true;
alphas = [0.0; 0.1; 0.2];
nIters = 1000;
initEst = 5 * ones(nArms, 1);
epsilons = [0.1; 0.2];
epsconst = [false; false];
% Run
eps_greedy_run(nArms, means, stdevs, stat, alphas, nIters, initEst, ...
    epsilons, epsconst)

%% Stochastic and non-stationary case: constant vs decreasing
close all;
nArms = 4;
means = zeros(nArms, 1);
stdevs = ones(nArms, 1);
stat = false;
alphas = [0.0; 0.1];
nIters = 10000;
initEst = 5 * ones(nArms, 1);
epsilons = 0.1;
epsconst = true;
% Run
eps_greedy_run(nArms, means, stdevs, stat, alphas, nIters, initEst, ...
    epsilons, epsconst)
