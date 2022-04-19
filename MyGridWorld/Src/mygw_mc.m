% ---------------------------------------- %
%  File: mygw_mc.m                         %
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

%% Monte Carlo params
gamma = 0.99;
nEpisodes = 1e1;

% Exploring start
MC_EXP = MonteCarlo(mygw, gamma, nEpisodes);

% Epsilon-greedy
MC_EPS = MonteCarlo(mygw, gamma, nEpisodes);

%% MC Control: Exploring start vs Epsilon-greedy
% Plots
fig = figure();
sgtitle(sprintf('GridWorld - Monte Carlo\nRepetitions: STOP'));
% MC EXP subfigure
ax1 = subplot(1, 2, 1);
title('Exploring start');
mygw.plot(ax1);
rects_exp = mygw.plotPath(ax1, mygw.run(0, MC_EXP.pi));
arrs_exp = mygw.plotPolicy(ax1, MC_EXP.pi);
% MC EPS subfigure
ax2 = subplot(1, 2, 2);
title('Epsilon greedy');
mygw.plot(ax2);
rects_eps = mygw.plotPath(ax2, mygw.run(0, MC_EPS.pi));
arrs_eps = mygw.plotPolicy(ax2, MC_EPS.pi);
pause();

% Iterate on repetitions
nRepetitions = 1e2;
fprintf('Repetions:  %3d%\n', 0);
for r = 1 : nRepetitions
    % Update repetition number
    fprintf('\b\b\b\b%3.0f%%', (r / nRepetitions) * 100);
    sgtitle(sprintf('GridWorld - Monte Carlo\nRepetitions: %d/%d', ...
        r, nRepetitions));
    
    % Exploring start
    MC_EXP = MC_EXP.controlExploring();
    % Delete old plots
    delete(rects_exp); delete(arrs_exp);
    % Plot Exploring start optimal policy
    rects_exp = mygw.plotPath(ax1, mygw.run(0, MC_EXP.pi));
    arrs_exp = mygw.plotPolicy(ax1, MC_EXP.pi);

    % Epsilon greedy
    MC_EPS = MC_EPS.controlEpsilon(0.1);
    % Delete old plots
    delete(rects_eps); delete(arrs_eps);
    % Plot Epsilon greedy optimal policy
    rects_eps = mygw.plotPath(ax2, mygw.run(0, MC_EPS.pi));
    arrs_eps = mygw.plotPolicy(ax2, MC_EPS.pi);
    
    % Force drawing
    drawnow
end
sgtitle(sprintf('GridWorld - Monte Carlo\nRepetitions: END'));
fprintf('\n');
