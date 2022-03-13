% ---------------------------------------- %
%  File: eps_greedy_main.m                 %
%  Date: February 22, 2022                 %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Deterministic and stationary case: constant vs decreasing eps
close all;
rng(1);
nArms = 4;
means = (1:nArms)';
stdevs = zeros(nArms, 1);
stat = true;
alphas = 0.0;
nIters = 1e2;
initEst = zeros(nArms, 1);
epsilons = [0.1; 0.1];
epsconst = [true; false];
% Run
eps_greedy_run(nArms, means, stdevs, stat, alphas, nIters, initEst, ...
    epsilons, epsconst)

% NOTES:
% Eps-dec after 3 iterations plays the arm #4 and then expolits it
% Eps-const continues to explore even after playing the arm #4
% Eps-dec is better than eps-const :)

%% Deterministic and stationary case: constant vs decreasing eps
close all;
rng(4);
% Run
eps_greedy_run(nArms, means, stdevs, stat, alphas, nIters, initEst, ...
    epsilons, epsconst)

% NOTES:
% Eps-dec never explores the arm #4, so exploits the arm #3
% Eps-const is better than exp-dec :(

%% Deterministic and stationary case: optimistic initialization
close all;
rng(4);
initEst = 5 * ones(nArms, 1);
% Run
eps_greedy_run(nArms, means, stdevs, stat, alphas, nIters, initEst, ...
    epsilons, epsconst)

% NOTES:
% Eps-dec thanks to the optimistic initialization explores the arm #4 
% and exploits it
% Eps-dec better than eps-const :), especially in the long term!
% Try with 1e5 iters!

%% Stochastic and stationary case: constant vs decreasing eps
close all;
rng(2);
nArms = 4;
means = (1:nArms)';
stdevs = 2 * ones(nArms, 1);
stat = true;
alphas = 0.0;
nIters = 2e2;
initEst = 5 * ones(nArms, 1);
epsilons = [0.1; 0.1];
epsconst = [true; false];
% Run
eps_greedy_run(nArms, means, stdevs, stat, alphas, nIters, initEst, ...
    epsilons, epsconst)

% NOTES:
% Eps-dec understimates the value of the arms #3 and #4, so exploits 
% the arm #3 :(
% Eps-const thanks to continuous exploration corrects the estimates
% Eps-const is better than eps-dec :)

%% Stochastic and non-stationary case: constant vs decreasing alpha
close all;
rng(0);
nArms = 4;
means = zeros(nArms, 1);
stdevs = ones(nArms, 1);
stat = false;
alphas = [0.0; 0.1];
nIters = 1e3;
initEst = 5 * ones(nArms, 1);
epsilons = 0.1;
epsconst = true;
% Run
eps_greedy_run(nArms, means, stdevs, stat, alphas, nIters, initEst, ...
    epsilons, epsconst)

% NOTES:
% Alpha-dec weighs past rewards like recent ones, so the estimates are
% wrong
% Alpha-const weighs recent rewards more, so it has better estimates
% The mean is a low-pass filter and alpha move the cutoff frequency 
