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
    fprintf("Created F1.mat\n");
end

%% Montecarlo Exploring start
if (exist([path, '/../Data/F1_MC_EXP.mat'], 'file') == 2)
    % Load Montecarlo Exploring start
    load([path, '/../Data/F1_MC_EXP.mat']);
    fprintf("Loaded F1_MC_EXP.mat\n");
else
    % Create Montecarlo Exploring start
    gamma = 0.99;
    nEpisodes = 1e1;
    MC_EXP = Montecarlo(track, gamma, nEpisodes);
    fprintf("Created F1_MC_EXP.mat\n");
end

%% Montecarlo Epsilon greedy
if (exist([path, '/../Data/F1_MC_EPS.mat'], 'file') == 2)
    % Load Montecarlo Epsilon greedy
    load([path, '/../Data/F1_MC_EPS.mat']);
    fprintf("Loaded F1_MC_EPS.mat\n");
else
    % Create Montecarlo Epsilon greedy
    gamma = 0.99;
    nEpisodes = 1e1;
    MC_EPS = Montecarlo(track, gamma, nEpisodes);
    fprintf("Created F1_MC_EPS.mat\n");
end

%% MC Control: Exploring start vs Epsilon-greedy
% Number of repetitions
nRepetitions = 1e3;
% Plot MC EXP vs MC EPS
fig = figure();
sgtitle(sprintf('GridWorld - Montecarlo\nRepetitions: 0/%d', nRepetitions));
% MC EXP subfigure
ax1 = subplot(1, 2, 1);
title('Exploring start');
track.plot(ax1);
[sts_exp, ~, ~] = track.run(0, MC_EXP.pi);
rects_exp = track.plotPath(ax1, sts_exp);
arrs_exp = track.plotPolicy(ax1, MC_EXP.pi);
% MC EPS subfigure
ax2 = subplot(1, 2, 2);
title('Epsilon greedy');
track.plot(ax2);
[sts_eps, ~, ~] = track.run(0, MC_EPS.pi);
rects_eps = track.plotPath(ax2, sts_eps);
arrs_eps = track.plotPolicy(ax2, MC_EPS.pi);
pause();

fprintf('Repetions:  %3d%\n', 0);
for r = 1 : nRepetitions
    % Update repetition number
    fprintf('\b\b\b\b%3.0f%%', (r / nRepetitions) * 100);
    sgtitle(sprintf('GridWorld - Montecarlo\nRepetitions: %d/%d', ...
        r, nRepetitions));

    % Run a repetition
    MC_EXP = MC_EXP.controlExploring();
    MC_EPS = MC_EPS.controlEpsilon(0.1);

    % Delete old plots
    delete(rects_exp); delete(arrs_exp);
    % Plot Exploring start optimal policy
    [sts_exp, ~, ~] = track.run(0, MC_EXP.pi);
    rects_exp = track.plotPath(ax1, sts_exp);
    arrs_exp = track.plotPolicy(ax1, MC_EXP.pi);
    % Delete old plots
    delete(rects_eps); delete(arrs_eps);
    % Plot Epsilon greedy optimal policy
    [sts_eps, ~, ~] = track.run(0, MC_EPS.pi);
    rects_eps = track.plotPath(ax2, sts_eps);
    arrs_eps = track.plotPolicy(ax2, MC_EPS.pi);
    % Force drawing
    drawnow
    % Save data
    %     save([path, '/../Data/F1_MC_EXP.mat'], 'MC_EXP');
    %     save([path, '/../Data/F1_MC_EXP.mat'], 'MC_EPS');
end
fprintf('\n');
