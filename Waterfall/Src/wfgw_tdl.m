% ---------------------------------------- %
%  File: wfgw_td.m                         %
%  Date: April 14, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Waterfall GridWorld
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

%% Temporal Difference Lambda params
alpha = 0.01;
gamma = 1.0;
eps = 0.1;
lambda = 0.9;
nEpisodes = 1e2;

% SARSA Accumulating traces
SARSA_acc = TempDiffLambda(wfgw, alpha, gamma, eps, lambda, ...
    nEpisodes);
% SARSA Accumulating traces
SARSA_repl = TempDiffLambda(wfgw, alpha, gamma, eps, lambda, ...
    nEpisodes);

% SARSA Accumulating traces
SARSA_dutch = TempDiffLambda(wfgw, alpha, gamma, eps, lambda, ...
    nEpisodes);

% Q-Learning Accumulating traces
QL_acc = TempDiffLambda(wfgw, alpha, gamma, eps, lambda, ...
    nEpisodes);
% Q-Learning Accumulating traces
QL_repl = TempDiffLambda(wfgw, alpha, gamma, eps, lambda, ...
    nEpisodes);

% Q-Learning Accumulating traces
QL_dutch = TempDiffLambda(wfgw, alpha, gamma, eps, lambda, ...
    nEpisodes);

%% SARSA: Accumulating vs Replacing vs Dutch traces
% Plots
figure();
sgtitle(sprintf('GridWorld - SARSA\nSTOP'));
% SARSA Accumulating traces subfigure
ax1 = subplot(1, 3, 1);
title('SARSA Accumulating traces');
wfgw.plot(ax1);
rects_acc = wfgw.plotPath(ax1, wfgw.run(0, SARSA_acc.pi));
arrs_acc = wfgw.plotPolicy(ax1, SARSA_acc.pi);
% SARSA Replacing traces subfigure
ax2 = subplot(1, 3, 2);
title('SARSA Replacing traces');
wfgw.plot(ax2);
rects_repl = wfgw.plotPath(ax2, wfgw.run(0, SARSA_repl.pi));
arrs_repl = wfgw.plotPolicy(ax2, SARSA_repl.pi);
% SARSA Dutch traces subfigure
ax3 = subplot(1, 3, 3);
title('SARSA Dutch traces');
wfgw.plot(ax3);
rects_dutch = wfgw.plotPath(ax3, wfgw.run(0, SARSA_dutch.pi));
arrs_dutch = wfgw.plotPolicy(ax3, SARSA_dutch.pi);

% Iterate on repetitions
nRepetitions = 1e2;
for r = 1 : nRepetitions
    % Update repetition number
    sgtitle(sprintf(['GridWorld - SARSA Lambda\n' ...
        'Repetitions: %d/%d\nEpisodes: %d'], ...
        r, nRepetitions, r*nEpisodes));

    % SARSA
    SARSA_acc = SARSA_acc.SARSALambda(1);
    % Delete old plots
    delete(rects_acc); delete(arrs_acc);
    % Plot Exploring start optimal policy
    rects_acc = wfgw.plotPath(ax1, wfgw.run(0, SARSA_acc.pi));
    arrs_acc = wfgw.plotPolicy(ax1, SARSA_acc.pi);

    % SARSA
    SARSA_repl = SARSA_repl.SARSALambda(2);
    % Delete old plots
    delete(rects_repl); delete(arrs_repl);
    % Plot Epsilon greedy optimal policy
    rects_repl = wfgw.plotPath(ax2, wfgw.run(0, SARSA_repl.pi));
    arrs_repl = wfgw.plotPolicy(ax2, SARSA_repl.pi);

    % QL
    SARSA_dutch = SARSA_dutch.SARSALambda(3);
    % Delete old plots
    delete(rects_dutch); delete(arrs_dutch);
    % Plot Epsilon greedy optimal policy
    rects_dutch = wfgw.plotPath(ax3, wfgw.run(0, SARSA_dutch.pi));
    arrs_dutch = wfgw.plotPolicy(ax3, SARSA_dutch.pi);

    % Force drawing
    drawnow
end
sgtitle(sprintf('GridWorld - SARSA Lambda\END'));
fprintf('\n');

%% QL: Accumulating vs Replacing vs Dutch traces
% Plots
fig = figure();
sgtitle(sprintf('GridWorld - QL\nSTOP'));
% QL Accumulating traces subfigure
ax1 = subplot(1, 3, 1);
title('QL Accumulating traces');
wfgw.plot(ax1);
rects_acc = wfgw.plotPath(ax1, wfgw.run(0, QL_acc.pi));
arrs_acc = wfgw.plotPolicy(ax1, QL_acc.pi);
% QL Replacing traces subfigure
ax2 = subplot(1, 3, 2);
title('QL Replacing traces');
wfgw.plot(ax2);
rects_repl = wfgw.plotPath(ax2, wfgw.run(0, QL_repl.pi));
arrs_repl = wfgw.plotPolicy(ax2, QL_repl.pi);
% QL Dutch traces subfigure
ax3 = subplot(1, 3, 3);
title('QL Dutch traces');
wfgw.plot(ax3);
rects_dutch = wfgw.plotPath(ax3, wfgw.run(0, QL_dutch.pi));
arrs_dutch = wfgw.plotPolicy(ax3, QL_dutch.pi);

% Iterate on repetitions
nRepetitions = 1e2;
for r = 1 : nRepetitions
    % Update repetition number
    sgtitle(sprintf(['GridWorld - QL Lambda\n' ...
        'Repetitions: %d/%d\nEpisodes: %d'], ...
        r, nRepetitions, r*nEpisodes));

    % SARSA
    QL_acc = QL_acc.SARSALambda(1);
    % Delete old plots
    delete(rects_acc); delete(arrs_acc);
    % Plot Exploring start optimal policy
    rects_acc = wfgw.plotPath(ax1, wfgw.run(0, QL_acc.pi));
    arrs_acc = wfgw.plotPolicy(ax1, QL_acc.pi);

    % SARSA
    QL_repl = QL_repl.SARSALambda(2);
    % Delete old plots
    delete(rects_repl); delete(arrs_repl);
    % Plot Epsilon greedy optimal policy
    rects_repl = wfgw.plotPath(ax2, wfgw.run(0, QL_repl.pi));
    arrs_repl = wfgw.plotPolicy(ax2, QL_repl.pi);

    % QL
    QL_dutch = QL_dutch.SARSALambda(3);
    % Delete old plots
    delete(rects_dutch); delete(arrs_dutch);
    % Plot Epsilon greedy optimal policy
    rects_dutch = wfgw.plotPath(ax3, wfgw.run(0, QL_dutch.pi));
    arrs_dutch = wfgw.plotPolicy(ax3, QL_dutch.pi);

    % Force drawing
    drawnow
end
sgtitle(sprintf('GridWorld - QL Lambda\END'));
fprintf('\n');