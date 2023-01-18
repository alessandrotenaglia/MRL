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
alphas = 0;
nIters = 300;
initEst = zeros(nArms, 1);
epsilons = 1;
epsconst = false;

% define input
input_file = 'Versione6_Oliva/input_CNR.xlsx';
action_table = 'Versione6_Oliva/actionsTable.xlsx';
exec_file = 'Versione6_Oliva/OPENNESS_RomaTermini_v3AUTO_linux.sh';
dir_results = 'Versione6_Oliva/Risultati';
dir_storage = 'Versione6_Oliva/Store';

% Run
eg = EpsGreedy_CNR(stat, alphas, nIters, initEst, ...
                   input_file, exec_file, dir_results, dir_storage, action_table, ...
                   epsilons, epsconst);
% eg = eg.read_store_dir();
eg = eg.run();


