% ---------------------------------------- %
%  File: f1_mdp.m                          %
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

%% Generate the MDP
track = track.generateMDP();
% Check that P is a stochastic matrix
S = round(sum(track.P, 3), 3);
for s = 1 : track.nStates
    for a = 1 : track.nActions
        if (S(s) ~= 1)
            disp("ERROR: P is not a stochastic matrix");
        end
    end
end

%% Save the track
save([path, '/../Data/F1_MDP.mat'], 'track');
