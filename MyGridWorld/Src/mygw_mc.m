% ---------------------------------------- %
%  File: mygw_mc.m                         %
%  Date: March 22, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Load/Create MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/../Data/MYGW.mat'], 'file') == 2)
    load([path, '/../Data/MYGW.mat']);
    fprintf("Loaded MYGW.mat\n");
else
    mygw_main;
    fprintf("Created MYGW.mat\n");
end

%% Load/Create Montecarlo Exploring start
if (exist([path, '/MYGW_MC_EXP.mat'], 'file') == 2)
    load([path, '/MYGW_MC_EXP.mat']);
    fprintf("Loaded MYGW_MC_EXP.mat\n");
else
    gamma = 0.99;
    nEpisodes = 1e3;
    MC_EXP = Montecarlo(mygw, gamma, nEpisodes);
    fprintf("Created MYGW_MC_EXP.mat\n");
end

%% Load/Create Montecarlo Epsilon greedy
if (exist([path, '/../Data/MYGW_MC_EPS.mat'], 'file') == 2)
    load([path, '/../Data/MYGW_MC_EPS.mat']);
    fprintf("Loaded MYGW_MC_EPS.mat\n");
else
    gamma = 0.99;
    nEpisodes = 1e3;
    MC_EPS = Montecarlo(mygw, gamma, nEpisodes);
    fprintf("Created MYGW_MC_EPS.mat\n");
end

%% MC Control
eps = 0.2;
nRepetitions = 1e1;
fprintf('Repetions:  %3d%\n', 0);
for r = 1 : nRepetitions
    fprintf('\b\b\b\b%3.0f%%', (r / nRepetitions) * 100);
    % Montecarlo Exploring start
    MC_EXP = MC_EXP.controlExploring();
    save([path, '/../Data/MYGW_MC_EXP.mat'], 'MC_EXP');
    % Montecarlo Epsilon greedy
    MC_EPS = MC_EPS.controlEpsilon(eps);
    save([path, '/../Data/MYGW_MC_EPS.mat'], 'MC_EPS');
end
fprintf('\n');

%% Plots PI vs VI
figure()
sgtitle('GridWorld - Montecarlo')
% Plot Exploring start optimal policy
subplot(1, 2, 1)
title('Exploring start')
mygw.plotPolicy(MC_EXP.policy)
[sts, ~, ~] = mygw.run(0, MC_EXP.policy);
mygw.plotPath(sts);
% Plot Epsilon greedy optimal policy
subplot(1, 2, 2)
title('Epsilon greedy')
mygw.plotPolicy(MC_EPS.policy)
[sts, ~, ~] = mygw.run(0, MC_EPS.policy);
mygw.plotPath(sts);
