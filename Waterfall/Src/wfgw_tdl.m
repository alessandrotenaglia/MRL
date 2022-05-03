% ---------------------------------------- %
%  File: wfgw_td.m                          %
%  Date: April 14, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/../Data/WFGW.mat'], 'file') == 2)
    % Load MyGridWorld
    load([path, '/../Data/WFGW.mat']);
    fprintf("Loaded WFGW.mat\n");
else
    % Create MyGridWorld
    wfgw_main;
    fprintf("Created WFGW\n");
end

%% Temporal Difference params
alpha = 0.01;
gamma = 1.0;
eps = 0.1;
lambda = 0.9;
nEpisodes = 1e2;

% SARSA Accumulating traces
SARSA_acc = TempDiffLambda(wfgw, alpha, eps, lambda, gamma, nEpisodes);

% SARSA Accumulating traces
SARSA_repl = TempDiffLambda(wfgw, alpha, eps, lambda, gamma, nEpisodes);

% SARSA Accumulating traces
SARSA_dutch = TempDiffLambda(wfgw, alpha, eps, lambda, gamma, nEpisodes);

%% Temporal Difference: SARSA vs ESARSA vs QL vs DQL
% Plots
fig = figure();
sgtitle(sprintf('GridWorld - Temporal Difference Lambda\nSTOP'));
% SARSA Accumulating traces subfigure
ax1 = subplot(1, 3, 1);
title('SARSA Accumulating traces');
wfgw.plot(ax1);
rects_sarsa_acc = wfgw.plotPath(ax1, wfgw.run(0, SARSA_acc.pi));
arrs_sarsa_acc = wfgw.plotPolicy(ax1, SARSA_acc.pi);
% SARSA Replacing traces subfigure
ax2 = subplot(1, 3, 2);
title('SARSA Replacing traces');
wfgw.plot(ax2);
rects_sarsa_repl = wfgw.plotPath(ax2, wfgw.run(0, SARSA_repl.pi));
arrs_sarsa_repl = wfgw.plotPolicy(ax2, SARSA_repl.pi);
% SARSA Dutch traces subfigure
ax3 = subplot(1, 3, 3);
title('SARSA Dutch traces');
wfgw.plot(ax3);
rects_sarsa_dutch = wfgw.plotPath(ax3, wfgw.run(0, SARSA_dutch.pi));
arrs_sarsa_dutch = wfgw.plotPolicy(ax3, SARSA_dutch.pi);

% Iterate on repetitions
nRepetitions = 1e2;
for r = 1 : nRepetitions
    % Update repetition number
    sgtitle(sprintf(['GridWorld - Temporal Difference\n' ...
        'Repetitions: %d/%d\nEpisodes: %d'], ...
        r, nRepetitions, r*nEpisodes));

    % SARSA
    SARSA_acc = SARSA_acc.SARSALambda(1);
    % Delete old plots
    delete(rects_sarsa_acc); delete(arrs_sarsa_acc);
    % Plot Exploring start optimal policy
    rects_sarsa_acc = wfgw.plotPath(ax1, wfgw.run(0, SARSA_acc.pi));
    arrs_sarsa_acc = wfgw.plotPolicy(ax1, SARSA_acc.pi);

    % SARSA
    SARSA_repl = SARSA_repl.SARSALambda(2);
    % Delete old plots
    delete(rects_sarsa_repl); delete(arrs_sarsa_repl);
    % Plot Epsilon greedy optimal policy
    rects_sarsa_repl = wfgw.plotPath(ax2, wfgw.run(0, SARSA_repl.pi));
    arrs_sarsa_repl = wfgw.plotPolicy(ax2, SARSA_repl.pi);

    % QL
    SARSA_dutch = SARSA_dutch.SARSALambda(3);
    % Delete old plots
    delete(rects_sarsa_dutch); delete(arrs_sarsa_dutch);
    % Plot Epsilon greedy optimal policy
    rects_sarsa_dutch = wfgw.plotPath(ax3, wfgw.run(0, SARSA_dutch.pi));
    arrs_sarsa_dutch = wfgw.plotPolicy(ax3, SARSA_dutch.pi);

    % Force drawing
    drawnow
end
% sgtitle(sprintf('GridWorld - Temporal Difference\END'));
% fprintf('\n');

function plotEligTraces(ax, E)
    hist3(ax, E);
end