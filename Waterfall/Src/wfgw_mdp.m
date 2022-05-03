% ---------------------------------------- %
%  File: wfgw_mdp.m                         %
%  Date: April 9, 2022                     %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/../Data/WFGW.mat'], 'file') == 2)
    % Load MyGridWorld
    load([path, '/../Data/WFGW.mat']);
    fprintf("Loaded WFGW.mat\n");
else
    % Create MyGridWorld
    wfgw_main;
    fprintf("Created WFGW\n");
end

%% Generate the MDP
wfgw = wfgw.generateMDP();
% Check that P is a stochastic matrix
S = round(sum(wfgw.P, 3), 3);
for s = 1 : wfgw.nStates
    for a = 1 : wfgw.nActions
        if (S(s) ~= 1)
            disp("ERROR: P is not a stochastic matrix")
        end
    end
end

%% Save MyGridWorld
save([path, '/../Data/WFGW_MDP.mat'], 'wfgw')
