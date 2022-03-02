% ---------------------------------------- %
%  File: pref_up_main.m                    %
%  Date: 22 February 2022                  %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Deterministic and stationary case
nArms = 4;
means = (1:nArms)';
stdevs = zeros(nArms, 1);
stat = true;
alphas = [0.0; 0.1; 0.2];
nIters = 100;
initEst = zeros(nArms, 1);
% Run
pref_up_run(nArms, means, stdevs, stat, alphas, nIters, initEst)

%% Stochastic and stationary case
nArms = 4;
means = (1:nArms)';
stdevs = ones(nArms, 1);
stat = true;
alphas = [0.0; 0.1; 0.2];
nIters = 500;
initEst = zeros(nArms, 1);
% Run
pref_up_run(nArms, means, stdevs, stat, alphas, nIters, initEst)

%% Stochastic and non-stationary case
nArms = 4;
means = zeros(nArms, 1);
stdevs = ones(nArms, 1);
stat = false;
alphas = [0.0; 0.1; 0.2];
nIters = 1000;
initEst = zeros(nArms, 1);
% Run
pref_up_run(nArms, means, stdevs, stat, alphas, nIters, initEst)