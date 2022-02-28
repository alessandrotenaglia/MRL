% ---------------------------------------- %
%  File: pref_up_main.m                    %
%  Date: 22 February 2022                  %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%%
nArms = 4;
means = (1:nArms)';
stdevs = zeros(nArms, 1);
stat = 1;
alphas = [0.0; 0.1];
nIters = 100;
initEst = zeros(nArms, 1);

pref_up_run(nArms, means, stdevs, stat, alphas, nIters, initEst)

%%