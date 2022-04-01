% ---------------------------------------- %
%  File: f1_mc.m                           %
%  Date: March 30, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Load/Create the track
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/F1.mat'], 'file') == 2)
    load([path, '/F1.mat']);
    fprintf("Loaded F1.mat\n");
else
    f1_main;
    fprintf("Created F1.mat\n");
end

%% Load/Create Montecarlo Exploring start
if (exist([path, '/F1_MC_EXP.mat'], 'file') == 2)
    load([path, '/F1_MC_EXP.mat']);
    fprintf("Loaded F1_MC_EXP.mat\n");
else
    gamma = 0.99;
    nEpisodes = 1e3;
    MC_EXP = Montecarlo(track, gamma, nEpisodes);
    fprintf("Created F1_MC_EXP.mat\n");
end

%% Load/Create Montecarlo Epsilon greedy
if (exist([path, '/F1_MC_EPS.mat'], 'file') == 2)
    load([path, '/F1_MC_EPS.mat']);
    fprintf("Loaded F1_MC_EPS.mat\n");
else
    gamma = 0.99;
    nEpisodes = 1e3;
    MC_EPS = Montecarlo(track, gamma, nEpisodes);
    fprintf("Created F1_MC_EPS.mat\n");
end

%% MC Control
eps = 0.2;
nRepetitions = 1e2;
fprintf('Repetions:  %3d%\n', 0);
for r = 1 : nRepetitions
    fprintf('\b\b\b\b%3.0f%%', (r / nRepetitions) * 100);
    % Montecarlo Exploring start
    MC_EXP = MC_EXP.controlExploring();
    save([path, '/F1_MC_EXP.mat'], 'MC_EXP');
    % Montecarlo Epsilon greedy
    MC_EPS = MC_EPS.controlEpsilon(eps);
    save([path, '/F1_MC_EPS.mat'], 'MC_EPS');
end
fprintf('\n');

%% Plots PI vs VI
figure()
sgtitle('GridWorld - Montecarlo')
% Plot Exploring start optimal policy
subplot(1, 2, 1)
title('Exploring start')
track.plotPolicy(MC_EXP.policy)
[sts, ~, ~] = track.run(0, MC_EXP.policy);
track.plotPath(sts);
% Plot Epsilon greedy optimal policy
subplot(1, 2, 2)
title('Epsilon greedy')
track.plotPolicy(MC_EPS.policy)
[sts, ~, ~] = track.run(0, MC_EPS.policy);
track.plotPath(sts);
