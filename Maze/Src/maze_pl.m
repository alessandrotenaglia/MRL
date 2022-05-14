% ---------------------------------------- %
%  File: maze_pl.m                         %
%  Date: May 12, 2022                      %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Maze
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/../Data/MAZE.mat'], 'file') == 2)
    % Load Maze
    load([path, '/../Data/MAZE.mat']);
    fprintf("Loaded MAZE.mat\n");
else
    % Create Maze
    maze_main;
    fprintf("Created MAZE\n");
end

%% Temproal Difference params
alpha = 0.1;
eps = 0.1;
gamma = 1.0;
nEpisodes = 1e1;

% Q-Learning Eligibility traces
QL = TempDiff(maze, alpha, eps, gamma, nEpisodes);

% DynaQ+
k = 0.01;
N = 100;
DynaPlus = DynaQplus(maze, alpha, eps, gamma, k, N, nEpisodes);

% DynaQ Priorized
theta = 0.1;
DynaPrio = DynaQprio(maze, alpha, eps, gamma, theta, nEpisodes);

%% Temporal Difference: SARSA vs ESARSA vs QL vs DQL
% Plots
fig = figure();
sgtitle(sprintf('Maze\nSTOP'));
% QLambda subfigure
ax1 = subplot(1, 3, 1);
title('QLambda');
maze.plot(ax1);
rects_ql = maze.plotPath(ax1, maze.run(0, QL.pi));
arrs_ql = maze.plotPolicy(ax1, QL.pi);
% DynaQ+ subfigure
ax2 = subplot(1, 3, 2);
title('DynaQ+');
maze.plot(ax2);
rects_plus = maze.plotPath(ax2, maze.run(0, DynaPlus.pi));
arrs_plus = maze.plotPolicy(ax2, DynaPlus.pi);
% DynaQ Priorized subfigure
ax3 = subplot(1, 3, 3);
title('DynaQ Priorized');
maze.plot(ax3);
rects_prio = maze.plotPath(ax3, maze.run(0, DynaPrio.pi));
arrs_prio = maze.plotPolicy(ax3, DynaPrio.pi);
pause;

% Iterate on repetitions
nRepetitions = 1e2;
for r = 1 : nRepetitions
    % Update repetition number
    sgtitle(sprintf(['Maze\n' ...
        'Repetitions: %d/%d\nEpisodes: %d'], ...
        r, nRepetitions, r*nEpisodes));

    % QLambda
    QL = QL.Qlearning();
    % Delete old plots
    delete(rects_ql); delete(arrs_ql);
    % Plot Exploring start optimal policy
    rects_ql = maze.plotPath(ax1, maze.run(0, QL.pi));
    arrs_ql = maze.plotPolicy(ax1, QL.pi);

    % DynaQ
    DynaPlus = DynaPlus.dyna();
    % Delete old plots
    delete(rects_plus); delete(arrs_plus);
    % Plot Epsilon greedy optimal policy
    rects_plus = maze.plotPath(ax2, maze.run(0, DynaPlus.pi));
    arrs_plus = maze.plotPolicy(ax2, DynaPlus.pi);

%     % DynaQ
%     DynaPrio = DynaPrio.dyna();
%     % Delete old plots
%     delete(rects_prio); delete(arrs_prio);
%     % Plot Epsilon greedy optimal policy
%     rects_prio = maze.plotPath(ax2, maze.run(0, DynaPrio.pi));
%     arrs_prio = maze.plotPolicy(ax2, DynaPrio.pi);

    % Force drawing
    drawnow
end
sgtitle(sprintf('Maze\nEND'));
fprintf('\n');
