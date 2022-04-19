% ---------------------------------------- %
%  File: wgw_td.m                          %
%  Date: April 14, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/../Data/WGW.mat'], 'file') == 2)
    % Load MyGridWorld
    load([path, '/../Data/WGW.mat']);
    fprintf("Loaded WGW.mat\n");
else
    % Create MyGridWorld
    wgw_main;
    fprintf("Created WGW\n");
end

%% Temproal Difference params
alpha = 0.1;
eps = 0.1;
gamma = 1.0;
nEpisodes = 1e2;

% SARSA
TD_SARSA = TempDiff(wgw, alpha, eps, gamma, nEpisodes);

% ESARSA
TD_ESARSA = TempDiff(wgw, alpha, eps, gamma, nEpisodes);

% Q-Learning
TD_QL = TempDiff(wgw, alpha, eps, gamma, nEpisodes);

% Double Q-Learning
TD_DQL = TempDiff(wgw, alpha, eps, gamma, nEpisodes);

%% Temporal Difference: SARSA vs ESARSA vs QL vs DQL
% Plots
fig = figure();
sgtitle(sprintf('GridWorld - Temporal Difference\nRepetitions: STOP'));
% SARSA subfigure
ax1 = subplot(2, 2, 1);
title('SARSA');
wgw.plot(ax1);
rects_sarsa = wgw.plotPath(ax1, wgw.run(0, TD_SARSA.pi));
arrs_sarsa = wgw.plotPolicy(ax1, TD_SARSA.pi);
% ESARSA subfigure
ax2 = subplot(2, 2, 2);
title('ESARSA');
wgw.plot(ax2);
rects_esarsa = wgw.plotPath(ax2, wgw.run(0, TD_ESARSA.pi));
arrs_esarsa = wgw.plotPolicy(ax2, TD_ESARSA.pi);
% SARSA subfigure
ax3 = subplot(2, 2, 3);
title('QL');
wgw.plot(ax3);
rects_ql = wgw.plotPath(ax3, wgw.run(0, TD_QL.pi));
arrs_ql = wgw.plotPolicy(ax3, TD_QL.pi);
% SARSA subfigure
ax4 = subplot(2, 2, 4);
title('DQL');
wgw.plot(ax4);
rects_dql = wgw.plotPath(ax4, wgw.run(0, TD_DQL.pi));
arrs_dql = wgw.plotPolicy(ax4, TD_DQL.pi);
pause();

% Iterate on repetitions
nRepetitions = 1e2;
fprintf('Repetions:  %3d%\n', 0);
for r = 1 : nRepetitions
    % Update repetition number
    fprintf('\b\b\b\b%3.0f%%', (r / nRepetitions) * 100);
    sgtitle(sprintf('GridWorld - Temporal Difference\nRepetitions: %d/%d', ...
        r, nRepetitions));

    % SARSA
    TD_SARSA = TD_SARSA.SARSA();
    % Delete old plots
    delete(rects_sarsa); delete(arrs_sarsa);
    % Plot Exploring start optimal policy
    rects_sarsa = wgw.plotPath(ax1, wgw.run(0, TD_SARSA.pi));
    arrs_sarsa = wgw.plotPolicy(ax1, TD_SARSA.pi);

    % ESARSA
    TD_ESARSA = TD_ESARSA.ESARSA();
    % Delete old plots
    delete(rects_esarsa); delete(arrs_esarsa);
    % Plot Epsilon greedy optimal policy
    rects_esarsa = wgw.plotPath(ax2, wgw.run(0, TD_ESARSA.pi));
    arrs_esarsa = wgw.plotPolicy(ax2, TD_ESARSA.pi);

    % QL
    TD_QL = TD_QL.Qlearning();
    % Delete old plots
    delete(rects_ql); delete(arrs_ql);
    % Plot Epsilon greedy optimal policy
    rects_ql = wgw.plotPath(ax3, wgw.run(0, TD_QL.pi));
    arrs_ql = wgw.plotPolicy(ax3, TD_QL.pi);

    % DQL
    TD_DQL = TD_DQL.DQlearning();
    % Delete old plots
    delete(rects_dql); delete(arrs_dql);
    % Plot Epsilon greedy optimal policy
    rects_dql = wgw.plotPath(ax4, wgw.run(0, TD_DQL.pi));
    arrs_dql = wgw.plotPolicy(ax4, TD_DQL.pi);

    % Force drawing
    drawnow
end
sgtitle(sprintf('GridWorld - Temporal Difference\nRepetitions: END'));
fprintf('\n');
