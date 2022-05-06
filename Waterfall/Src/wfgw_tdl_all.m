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
nEpisodes = 1e3;

% SARSA
SARSA = TempDiff(wfgw, alpha, gamma, eps, nEpisodes);

% SARSA Accumulating traces
SARSA_acc = TempDiffLambda(wfgw, alpha, gamma, eps, lambda, ...
    nEpisodes);

% SARSA Accumulating traces
SARSA_repl = TempDiffLambda(wfgw, alpha, gamma, eps, lambda, ...
    nEpisodes);

% SARSA Accumulating traces
SARSA_dutch = TempDiffLambda(wfgw, alpha, gamma, eps, lambda, ...
    nEpisodes);

% Q-Learning
QL = TempDiff(wfgw, alpha, gamma, eps, nEpisodes);

% Q-Learning Accumulating traces
QL_acc = TempDiffLambda(wfgw, alpha, gamma, eps, lambda, ...
    nEpisodes);

% Q-Learning Accumulating traces
QL_repl = TempDiffLambda(wfgw, alpha, gamma, eps, lambda, ...
    nEpisodes);

% Q-Learning Accumulating traces
QL_dutch = TempDiffLambda(wfgw, alpha, gamma, eps, lambda, ...
    nEpisodes);

%% SARSA vs QL : Accumulating vs Replacing vs Dutch traces
% Plots
figure(); sgtitle(sprintf('GridWorld - SARSA\nSTOP'));
% SARSA subfigure
ax11 = subplot(2, 4, 1); title('SARSA');
wfgw.plot(ax11);
sarsa_rects = wfgw.plotPath(ax11, wfgw.run(0, SARSA.pi));
sarsa_arrs = wfgw.plotPolicy(ax11, SARSA.pi);
% SARSA Accumulating traces subfigure
ax12 = subplot(2, 4, 2); title('SARSA Accumulating traces');
wfgw.plot(ax12);
sarsa_rects_acc = wfgw.plotPath(ax12, wfgw.run(0, SARSA_acc.pi));
sarsa_arrs_acc = wfgw.plotPolicy(ax12, SARSA_acc.pi);
% SARSA Replacing traces subfigure
ax13 = subplot(2, 4, 3); title('SARSA Replacing traces');
wfgw.plot(ax13);
sarsa_rects_repl = wfgw.plotPath(ax13, wfgw.run(0, SARSA_repl.pi));
sarsa_arrs_repl = wfgw.plotPolicy(ax13, SARSA_repl.pi);
% SARSA Dutch traces subfigure
ax14 = subplot(2, 4, 4); title('SARSA Dutch traces');
wfgw.plot(ax14);
sarsa_rects_dutch = wfgw.plotPath(ax14, wfgw.run(0, SARSA_dutch.pi));
sarsa_arrs_dutch = wfgw.plotPolicy(ax14, SARSA_dutch.pi);

% QL subfigure
ax21 = subplot(2, 4, 5); title('QL');
wfgw.plot(ax21);
ql_rects = wfgw.plotPath(ax21, wfgw.run(0, QL.pi));
ql_arrs = wfgw.plotPolicy(ax21, QL.pi);
% QL Accumulating traces subfigure
ax22 = subplot(2, 4, 6); title('QL Accumulating traces');
wfgw.plot(ax22);
ql_rects_acc = wfgw.plotPath(ax22, wfgw.run(0, QL_acc.pi));
ql_arrs_acc = wfgw.plotPolicy(ax22, QL_acc.pi);
% QL Replacing traces subfigure
ax23 = subplot(2, 4, 7); title('QL Replacing traces');
wfgw.plot(ax23);
ql_rects_repl = wfgw.plotPath(ax23, wfgw.run(0, QL_repl.pi));
ql_arrs_repl = wfgw.plotPolicy(ax23, QL_repl.pi);
% QL Dutch traces subfigure
ax24 = subplot(2, 4, 8); title('QL Dutch traces');
wfgw.plot(ax24);
ql_rects_dutch = wfgw.plotPath(ax24, wfgw.run(0, QL_dutch.pi));
ql_arrs_dutch = wfgw.plotPolicy(ax24, QL_dutch.pi);

% Iterate on repetitions
nRepetitions = 1e2;
for r = 1 : nRepetitions
    % Update repetition number
    sgtitle(sprintf(['GridWorld - SARSA Lambda\n' ...
        'Repetitions: %d/%d\nEpisodes: %d'], ...
        r, nRepetitions, r*nEpisodes));

    % SARSA
    SARSA = SARSA.SARSA();
    % Delete old plots
    delete(sarsa_rects); delete(sarsa_arrs);
    % Plot Exploring start optimal policy
    sarsa_rects = wfgw.plotPath(ax11, wfgw.run(0, SARSA.pi));
    sarsa_arrs = wfgw.plotPolicy(ax11, SARSA.pi);

    % SARSA Accumulating traces
    SARSA_acc = SARSA_acc.SARSALambda(1);
    % Delete old plots
    delete(sarsa_rects_acc); delete(sarsa_arrs_acc);
    % Plot Exploring start optimal policy
    sarsa_rects_acc = wfgw.plotPath(ax12, wfgw.run(0, SARSA_acc.pi));
    sarsa_arrs_acc = wfgw.plotPolicy(ax12, SARSA_acc.pi);

    % SARSA Replacing traces
    SARSA_repl = SARSA_repl.SARSALambda(2);
    % Delete old plots
    delete(sarsa_rects_repl); delete(sarsa_arrs_repl);
    % Plot Epsilon greedy optimal policy
    sarsa_rects_repl = wfgw.plotPath(ax13, wfgw.run(0, SARSA_repl.pi));
    sarsa_arrs_repl = wfgw.plotPolicy(ax13, SARSA_repl.pi);

    % SARSA Dutch traces
    SARSA_dutch = SARSA_dutch.SARSALambda(3);
    % Delete old plots
    delete(sarsa_rects_dutch); delete(sarsa_arrs_dutch);
    % Plot Epsilon greedy optimal policy
    sarsa_rects_dutch = wfgw.plotPath(ax14, wfgw.run(0, SARSA_dutch.pi));
    sarsa_arrs_dutch = wfgw.plotPolicy(ax14, SARSA_dutch.pi);

    % QL
    QL = QL.Qlearning();
    % Delete old plots
    delete(ql_rects); delete(ql_arrs);
    % Plot Exploring start optimal policy
    ql_rects = wfgw.plotPath(ax21, wfgw.run(0, QL.pi));
    ql_arrs = wfgw.plotPolicy(ax21, QL.pi);

    % QL Accumulating traces
    QL_acc = QL_acc.QLambda(1);
    % Delete old plots
    delete(ql_rects_acc); delete(ql_arrs_acc);
    % Plot Exploring start optimal policy
    ql_rects_acc = wfgw.plotPath(ax22, wfgw.run(0, QL_acc.pi));
    ql_arrs_acc = wfgw.plotPolicy(ax22, QL_acc.pi);

    % QL Replacing traces
    QL_repl = QL_repl.QLambda(2);
    % Delete old plots
    delete(ql_rects_repl); delete(ql_arrs_repl);
    % Plot Epsilon greedy optimal policy
    ql_rects_repl = wfgw.plotPath(ax23, wfgw.run(0, QL_repl.pi));
    ql_arrs_repl = wfgw.plotPolicy(ax23, QL_repl.pi);

    % QL Dutch traces
    QL_dutch = QL_dutch.QLambda(3);
    % Delete old plots
    delete(ql_rects_dutch); delete(ql_arrs_dutch);
    % Plot Epsilon greedy optimal policy
    ql_rects_dutch = wfgw.plotPath(ax24, wfgw.run(0, QL_dutch.pi));
    ql_arrs_dutch = wfgw.plotPolicy(ax24, QL_dutch.pi);

    % Force drawing
    drawnow
end
sgtitle(sprintf('GridWorld - SARSA Lambda\END'));
fprintf('\n');
