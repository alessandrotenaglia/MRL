% ---------------------------------------- %
%  File: f1_mc.m                           %
%  Date: March 30, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Load/Create the track
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/F1.mat'], 'file') == 2)
    load([path, '/F1.mat']);
else
    f1_main;
end

%% Load/Create Montecarlo
if (exist([path, '/F1_MC.mat'], 'file') == 2)
    load([path, '/F1_MC.mat']);
else
    eps = 0.1;
    gamma = 0.9;
    nEpisodes = 1e3;
    MC = Montecarlo(eps, gamma, nEpisodes);
end

%% MC Control
for e = 1 : 1e3
    MC = MC.control(track);
    save([path, '/F1_MC.mat'], 'MC');
end

%% Plot
figure()
title('MC - Optimal policy');
[sts, acts, rews] = track.run(0, MC.policy, 0.0);
track.plotPolicy(MC.policy);
track.plotPath(sts);

%% Save MyGridWorld
save([path, '/F1_MC.mat'], 'MC');
