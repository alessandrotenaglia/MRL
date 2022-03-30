% ---------------------------------------- %
%  File: mygw_mc.m                         %
%  Date: March 22, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Load/Create MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/MYGW.mat'], 'file') == 2)
    load([path, '/MYGW.mat']);
else
    f1_main;
end

%% Load/Create Montecarlo
if (exist([path, '/MYGW_MC.mat'], 'file') == 2)
    load([path, '/MYGW_MC.mat']);
else
    eps = 0.1;
    gamma = 0.9;
    nEpisodes = 1e3;
    MC = Montecarlo(eps, gamma, nEpisodes);
end

%% MC Control
for e = 1 : 1e3
    MC = MC.control(mygw);
    save([path, '/MYGW_MC.mat'], 'MC');
end

%% Plot
figure()
title('MC - Optimal policy');
[sts, acts, rews] = mygw.run(0, MC.policy, 0.0);
track.plotPolicy(MC.policy);
track.plotPath(sts);

%% Save MyGridWorld
save([path, '/MYGW_MC.mat'], 'MC');
