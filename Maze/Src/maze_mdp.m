% ---------------------------------------- %
%  File: maze_mdp.m                        %
%  Date: May 12, 2022                      %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% MyGridWorld
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
if (exist([path, '/../Data/MAZE.mat'], 'file') == 2)
    % Load MyGridWorld
    load([path, '/../Data/MAZE.mat']);
    fprintf("Loaded MAZE.mat\n");
else
    % Create MyGridWorld
    maze_main;
    fprintf("Created MAZE\n");
end

%% Generate the MDP
maze = maze.generateMDP();
% Check that P is a stochastic matrix
S = round(sum(maze.P, 3), 3);
for s = 1 : maze.nStates
    for a = 1 : maze.nActions
        if (S(s) ~= 1)
            disp("ERROR: P is not a stochastic matrix")
        end
    end
end

%% Save MyGridWorld
save([path, '/../Data/MAZE_MDP.mat'], 'maze')
