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
alpha = 0.1;
eps = 0.1;
gamma = 1.0;
nEpisodes = 5e1;

% SARSA
lambda = 0;
SARSA_0 = TempDiffLambda(wfgw, alpha, eps, gamma, lambda, nEpisodes);

% SARSA Eligibility traces
lambda = 0.2;
SARSA_lambda = TempDiffLambda(wfgw, alpha, eps, gamma, lambda, nEpisodes);

% Q-Learning
lambda = 0;
QL_0 = TempDiffLambda(wfgw, alpha,eps, gamma, lambda, nEpisodes);

% Q-Learning Eligibility traces
lambda = 0.2;
QL_lambda = TempDiffLambda(wfgw, alpha, eps, gamma, lambda, nEpisodes);

%% SARSA vs QL : Accumulating vs Replacing vs Dutch traces
% Plots
figure(); sgtitle(sprintf('GridWorld - SARSA\nSTOP'));
% SARSA subfigure
ax1 = subplot(2, 2, 1);
title('SARSA');
wfgw.plot(ax1);
sarsa_rects = wfgw.plotPath(ax1, wfgw.run(0, SARSA_0.pi));
sarsa_arrs = wfgw.plotPolicy(ax1, SARSA_0.pi);
% SARSA Eligibility traces subfigure
ax2 = subplot(2, 2, 2);
title('SARSA Eligibility traces');
wfgw.plot(ax2);
sarsa_et_rects = wfgw.plotPath(ax2, wfgw.run(0, SARSA_lambda.pi));
sarsa_et_arrs = wfgw.plotPolicy(ax2, SARSA_lambda.pi);
% QL subfigure
ax3 = subplot(2, 2, 3);
title('QL');
wfgw.plot(ax3);
ql_rects = wfgw.plotPath(ax3, wfgw.run(0, QL_0.pi));
ql_arrs = wfgw.plotPolicy(ax3, QL_0.pi);
% QL Eligibility traces subfigure
ax4 = subplot(2, 2, 4);
title('QL Eligibility traces');
wfgw.plot(ax4);
ql_et_rects = wfgw.plotPath(ax4, wfgw.run(0, QL_lambda.pi));
ql_et_arrs = wfgw.plotPolicy(ax4, QL_lambda.pi);

% Iterate on repetitions
nRepetitions = 1e2;
for r = 1 : nRepetitions
    % Update repetition number
    sgtitle(sprintf(['GridWorld - SARSA Lambda\n' ...
        'Repetitions: %d/%d\nEpisodes: %d'], ...
        r, nRepetitions, r*nEpisodes));

    % SARSA
    SARSA_0 = SARSA_0.SARSALambda(2);
    % Delete old plots
    delete(sarsa_rects); delete(sarsa_arrs);
    % Plot SARSA optimal policy
    sarsa_rects = wfgw.plotPath(ax1, wfgw.run(0, SARSA_0.pi));
    sarsa_arrs = wfgw.plotPolicy(ax1, SARSA_0.pi);

    % SARSA Eligibility traces
    SARSA_lambda = SARSA_lambda.SARSALambda(2);
    % Delete old plots
    delete(sarsa_et_rects); delete(sarsa_et_arrs);
    % Plot SARSA Lambda optimal policy
    sarsa_et_rects = wfgw.plotPath(ax2, wfgw.run(0, SARSA_lambda.pi));
    sarsa_et_arrs = wfgw.plotPolicy(ax2, SARSA_lambda.pi);

    % QL
    QL_0 = QL_0.QLambda(2);
    % Delete old plots
    delete(ql_rects); delete(ql_arrs);
    % Plot QL optimal policy
    ql_rects = wfgw.plotPath(ax3, wfgw.run(0, QL_0.pi));
    ql_arrs = wfgw.plotPolicy(ax3, QL_0.pi);

    % QL Eligibility traces
    QL_lambda = QL_lambda.QLambda(2);
    % Delete old plots
    delete(ql_et_rects); delete(ql_et_arrs);
    % Plot QL Lambda optimal policy
    ql_et_rects = wfgw.plotPath(ax4, wfgw.run(0, QL_lambda.pi));
    ql_et_arrs = wfgw.plotPolicy(ax4, QL_lambda.pi);

    % Force drawing
    drawnow
end
sgtitle(sprintf('GridWorld - SARSA Lambda\END'));
fprintf('\n');
