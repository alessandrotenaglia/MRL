% ---------------------------------------- %
%  File: mygw_mdp.m                        %
%  Date: March 22, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Load/Create MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/../Data/MYGW.mat'], 'file') == 2)
    load([path, '/../Data/MYGW.mat']);
    fprintf("Loaded MYGW.mat\n");
else
    mygw_main;
    fprintf("Created MYGW.mat\n");
end

%% MDP - P
% Generate the transition matrix
mygw = mygw.generateP();
% Check that P is a stochastic matrix
S = round(sum(mygw.P, 3), 3);
for s = 1 : mygw.nStates
    for a = 1 : mygw.nActions
        if (S(s) ~= 1)
            disp("ERROR: P is not a stochastic matrix")
        end
    end
end

%% MDP - R
% Generate the reward matrix
mygw = mygw.generateR();

%% Save MyGridWorld
save([path, '/../Data/MYGW_MDP.mat'], 'mygw')