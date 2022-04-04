% ---------------------------------------- %
%  File: f1_mc.m                           %
%  Date: March 30, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Track
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/../Data/F1.mat'], 'file') == 2)
    % Load the track
    load([path, '/../Data/F1.mat']);
    fprintf("Loaded F1.mat\n");
else
    % Create the track
    f1_main;
    fprintf("Created F1\n");
end

%% Monte Carlo Exploring start
if (exist([path, '/../Data/F1_MC_EXP.mat'], 'file') == 2)
    % Load Monte Carlo Exploring start
    load([path, '/../Data/F1_MC_EXP.mat']);
    fprintf("Loaded F1_MC_EXP.mat\n");
else
    % Create Monte Carlo Exploring start
    gamma = 0.99;
    nEpisodes = 1e4;
    MC_EXP = MonteCarlo(track, gamma, nEpisodes);
    fprintf("Created F1_MC_EXP\n");
end

%% Monte Carlo Epsilon greedy
if (exist([path, '/../Data/F1_MC_EPS.mat'], 'file') == 2)
    % Load Monte Carlo Epsilon greedy
    load([path, '/../Data/F1_MC_EPS.mat']);
    fprintf("Loaded F1_MC_EPS.mat\n");
else
    % Create Monte Carlo Epsilon greedy
    gamma = 0.99;
    nEpisodes = 1e4;
    MC_EPS = MonteCarlo(track, gamma, nEpisodes);
    fprintf("Created F1_MC_EPS\n");
end

%% MC Control: Exploring start vs Epsilon-greedy
% Plot MC EXP vs MC EPS
fig = figure();
sgtitle(sprintf('GridWorld - Monte Carlo\nRepetitions: STOP'));
% MC EXP subfigure
ax1 = subplot(1, 2, 1);
title('Exploring start');
track.plot(ax1);
rects_exp = track.plotPath(ax1, track.run(0, MC_EXP.pi));
arrs_exp = track.plotPolicy(ax1, MC_EXP.pi);
% MC EPS subfigure
ax2 = subplot(1, 2, 2);
title('Epsilon greedy');
track.plot(ax2);
rects_eps = track.plotPath(ax2, track.run(0, MC_EPS.pi));
arrs_eps = track.plotPolicy(ax2, MC_EPS.pi);
pause();

% Iterate on repetition
fprintf('Repetions:  %3d%\n', 0);
nRepetitions = 1e2;
for r = 1 : nRepetitions
    % Run a repetition
    MC_EXP = MC_EXP.controlExploring();
    MC_EPS = MC_EPS.controlEpsilon(0.1);

    % Update repetition number
    fprintf('\b\b\b\b%3.0f%%', (r / nRepetitions) * 100);
    sgtitle(sprintf('GridWorld - Monte Carlo\nRepetitions: %d/%d', ...
        r, nRepetitions));
    % Delete old plots
    delete(rects_exp); delete(arrs_exp);
    % Plot Exploring start optimal policy
    rects_exp = track.plotPath(ax1, track.run(0, MC_EXP.pi));
    arrs_exp = track.plotPolicy(ax1, MC_EXP.pi);
    % Delete old plots
    delete(rects_eps); delete(arrs_eps);
    % Plot Epsilon greedy optimal policy
    rects_eps = track.plotPath(ax2, track.run(0, MC_EPS.pi));
    arrs_eps = track.plotPolicy(ax2, MC_EPS.pi);
    % Force drawing
    drawnow
    % Save data
%     save([path, '/../Data/F1_MC_EXP.mat'], 'MC_EXP');
%     save([path, '/../Data/F1_MC_EPS.mat'], 'MC_EPS');
end
fprintf('\n');
sgtitle(sprintf('GridWorld - Monte Carlo\nRepetitions: END'));
