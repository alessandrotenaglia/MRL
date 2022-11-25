% ---------------------------------------- %
%  File: eps_main.m                        %
%  Date: February 22, 2022                 %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Deterministic and stationary case: constant vs decreasing eps
close all;
rng(1);
nArms = 1;
stat = true;
alphas = 0.0;
nIters = 2e2;
initEst = zeros(nArms, 1);
epsilons = 0.1;
epsconst = true;

% define input
input_file = 'Openness_model/input_CNR.xlsx';
output_file = 'Openness_model/Risultati/1905893_OUTPUTRisk.csv';
action_table = 'Openness_model/actionsTable.xlsx';
exec_file = 'Openness_model/OPENNESS_RomaTermini_v3AUTO_linux.sh';
dir_results = 'Openness_model/Risultati';

% Run
eg = EpsGreedy_CNR(stat, alphas, nIters, initEst, ...
                   input_file, exec_file, dir_results, action_table, ...
                   epsilons, epsconst);
eg = eg.run();


