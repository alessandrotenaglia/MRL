% ---------------------------------------- %
%  File: wgw_mdp.m                         %
%  Date: April 9, 2022                     %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/../Data/WGW.mat'], 'file') == 2)
    % Load MyGridWorld
    load([path, '/../Data/WGW.mat']);
    fprintf("Loaded WGW.mat\n");
else
    % Create MyGridWorld
    wgw_main;
    fprintf("Created WGW\n");
end

%% Generate the MDP
wgw = wgw.generateMDP();
% Check that P is a stochastic matrix
S = round(sum(wgw.P, 3), 3);
for s = 1 : wgw.nStates
    for a = 1 : wgw.nActions
        if (S(s) ~= 1)
            disp("ERROR: P is not a stochastic matrix")
        end
    end
end

%% Save MyGridWorld
save([path, '/../Data/WGW_MDP.mat'], 'wgw')
