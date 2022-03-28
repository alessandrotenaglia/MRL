% ---------------------------------------- %
%  File: mygw_mc.m                         %
%  Date: March 11, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% My Grid World
nX = 5;
nY = 5;
nActions = 8;
termCells = [nX; nY];
obstCells = [2, 2, 3; 2, 3, 2];
mygw = MyGridWorld(nX, nY, nActions, termCells, obstCells);
figure()
mygw.plotGrid();

%% MC Prediction
eps = 0.1;
gamma = 0.9;
nEpisodes = 1e4;
MC = Montecarlo(eps, gamma, nEpisodes);
% Generate a randomic policy
policy = randi(mygw.nActions, mygw.nStates, 1);
% Estimate the value function
MC = MC.prediction(mygw, policy);

figure()
sgtitle('GridWorld - Montecarlo')
% Plot the policy
subplot(2, 1, 1)
title('MC - Policy')
mygw.plotPolicy(MC.policy)
% Plot the value function
subplot(2, 1, 2)
title('MC - Value function')
mygw.plotValue(MC.value)

%% MC Control
eps = 0.1;
gamma = 0.9;
nEpisodes = 1e4;
MC = Montecarlo(eps, gamma, nEpisodes);
% Find the optimal policy
MC = MC.control(mygw);

figure()
sgtitle('GridWorld - Montecarlo')
% Plot the policy
subplot(2, 1, 1)
title('MC - Optimal policy')
mygw.plotPolicy(MC.policy)
% Plot the value function
subplot(2, 1, 2)
title('MC - Optimal value function')
mygw.plotValue(MC.value)
