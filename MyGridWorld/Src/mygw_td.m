% ---------------------------------------- %
%  File: mygw_td.m                         %
%  Date: March 22, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/../Data/MYGW.mat'], 'file') == 2)
    % Load MyGridWorld
    load([path, '/../Data/MYGW.mat']);
    fprintf("Loaded MYGW.mat\n");
else
    % Create MyGridWorld
    mygw_main;
    fprintf("Created MYGW\n");
end

%% Temproal Difference params
alpha = 0.1;
eps = 0.1;
gamma = 0.99;
nEpisodes = 1e1;

% SARSA
TD_SARSA = TempDiff(mygw, alpha, eps, gamma, nEpisodes);

% ESARSA
TD_ESARSA = TempDiff(mygw, alpha, eps, gamma, nEpisodes);

% Q-Learning
TD_QL = TempDiff(mygw, alpha, eps, gamma, nEpisodes);

% Double Q-Learning
TD_DQL = TempDiff(mygw, alpha, eps, gamma, nEpisodes);

%% Temporal Difference: SARSA vs ESARSA vs QL vs DQL
% Plots
fig = figure();
sgtitle(sprintf('GridWorld - Temporal Difference\nSTOP'));
% SARSA subfigure
ax1 = subplot(2, 2, 1);
title('SARSA');
mygw.plot(ax1);
rects_sarsa = mygw.plotPath(ax1, mygw.run(0, TD_SARSA.pi));
arrs_sarsa = mygw.plotPolicy(ax1, TD_SARSA.pi);
% ESARSA subfigure
ax2 = subplot(2, 2, 2);
title('ESARSA');
mygw.plot(ax2);
rects_esarsa = mygw.plotPath(ax2, mygw.run(0, TD_ESARSA.pi));
arrs_esarsa = mygw.plotPolicy(ax2, TD_ESARSA.pi);
% SARSA subfigure
ax3 = subplot(2, 2, 3);
title('QL');
mygw.plot(ax3);
rects_ql = mygw.plotPath(ax3, mygw.run(0, TD_QL.pi));
arrs_ql = mygw.plotPolicy(ax3, TD_QL.pi);
% SARSA subfigure
ax4 = subplot(2, 2, 4);
title('DQL');
mygw.plot(ax4);
rects_dql = mygw.plotPath(ax4, mygw.run(0, TD_DQL.pi));
arrs_dql = mygw.plotPolicy(ax4, TD_DQL.pi);
pause();

% Iterate on repetitions
nRepetitions = 1e2;
for r = 1 : nRepetitions
    % Update repetition number
    sgtitle(sprintf(['GridWorld - Temporal Difference\n' ...
        'Repetitions: %d/%d\nEpisodes: %d'], ...
        r, nRepetitions, r*nEpisodes));

    % SARSA
    TD_SARSA = TD_SARSA.SARSA();
    % Delete old plots
    delete(rects_sarsa); delete(arrs_sarsa);
    % Plot Exploring start optimal policy
    rects_sarsa = mygw.plotPath(ax1, mygw.run(0, TD_SARSA.pi));
    arrs_sarsa = mygw.plotPolicy(ax1, TD_SARSA.pi);

    % ESARSA
    TD_ESARSA = TD_ESARSA.ESARSA();
    % Delete old plots
    delete(rects_esarsa); delete(arrs_esarsa);
    % Plot Epsilon greedy optimal policy
    rects_esarsa = mygw.plotPath(ax2, mygw.run(0, TD_ESARSA.pi));
    arrs_esarsa = mygw.plotPolicy(ax2, TD_ESARSA.pi);

    % QL
    TD_QL = TD_QL.Qlearning();
    % Delete old plots
    delete(rects_ql); delete(arrs_ql);
    % Plot Epsilon greedy optimal policy
    rects_ql = mygw.plotPath(ax3, mygw.run(0, TD_QL.pi));
    arrs_ql = mygw.plotPolicy(ax3, TD_QL.pi);

    % DQL
    TD_DQL = TD_DQL.DQlearning();
    % Delete old plots
    delete(rects_dql); delete(arrs_dql);
    % Plot Epsilon greedy optimal policy
    rects_dql = mygw.plotPath(ax4, mygw.run(0, TD_DQL.pi));
    arrs_dql = mygw.plotPolicy(ax4, TD_DQL.pi);

    % Force drawing
    drawnow
end
sgtitle(sprintf('GridWorld - Temporal Difference\nEND'));
fprintf('\n');
