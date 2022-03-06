% ---------------------------------------- %
%  File: pref_up_main.m                    %
%  Date: February 22, 2022                 %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Deterministic and stationary case
close all;
rng(0);
nArms = 4;
means = (1:nArms)';
stdevs = zeros(nArms, 1);
stat = true;
alphas = [0.0; 0.01; 0.1];
nIters = 1e3;
initEst = zeros(nArms, 1);
% Run
pref_up_run(nArms, means, stdevs, stat, alphas, nIters, initEst)

% NOTES:
% In the deterministic and stationary case a step size euqal to iterations
% is better

%% Stochastic and stationary case
close all;
rng(0);
nArms = 4;
means = (1:nArms)';
stdevs = 2 * ones(nArms, 1);
stat = true;
alphas = [0.0; 0.01; 0.1];
nIters = 1e3;
initEst = zeros(nArms, 1);
% Run
pref_up_run(nArms, means, stdevs, stat, alphas, nIters, initEst)

% NOTES:
% The mean is a low-pass filter and alpha move the cutoff frequency

%% Stochastic and non-stationary case
close all;
rng(0);
nArms = 4;
means = zeros(nArms, 1);
stdevs = 2 * ones(nArms, 1);
stat = false;
alphas = [0.0; 0.01; 0.1];
nIters = 1e3;
initEst = zeros(nArms, 1);
% Run
pref_up_run(nArms, means, stdevs, stat, alphas, nIters, initEst)

% NOTES:
% The accuracy of the estimates grows as alpha grows
