% ---------------------------------------- %
%  File: mygw_mc.m                         %
%  Date: March 11, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Load MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/F1.mat'], 'file') == 2)
    load([path, '/F1.mat'])
else
    f1_main;
end

%% Load MyGridWorld
if (exist([path, '/F1_MC.mat'], 'file') == 2)
    load([path, '/F1_MC.mat'])
else
    eps = 0.1;
    gamma = 0.9;
    nEpisodes = 1e4;
    MC = Montecarlo(eps, gamma, nEpisodes);
end

%% MC Control
for e = 1 : 1e2
    MC = MC.control(track);
    save([path, '/F1_MC.mat'], 'MC')
end

%% Plots PI vs VI
figure()
title('MC - Optimal policy')
[sts, acts, rews] = track.run(MC.policy, 0.0);
figure()
track.plotPolicy(MC.policy);
track.plotPath(sts);

%% Save MyGridWorld
save([path, '/F1_MC.mat'], 'MC')
