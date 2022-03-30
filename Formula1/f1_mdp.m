% ---------------------------------------- %
%  File: mygw_mdp.m                        %
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

%% MDP - P
% Generate the transition matrix
track = track.generateP();
S = round(sum(track.P, 3), 3);
for s = 1 : track.nStates
    for a = 1 : track.nActions
        if (S(s) ~= 1)
            disp("ERROR: P is not a stochastic matrix")
        end
    end
end

%% MDP - R
% Generate the reward matrix
track = track.generateR();

%% Save MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
save([path, '/F1.mat'], 'track')
