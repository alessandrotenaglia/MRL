% ---------------------------------------- %
%  File: mygw_mc.m                        %
%  Date: March 11, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% My Grid World
nX = 5;
nY = 5;
nActions = 4;
termCells = [5;5];
obstCells = [2, 2, 3; 2, 3, 2];
mygw = MyGridWorld(nX, nY, nActions, termCells, obstCells);
figure()
mygw.plotGrid();

%% MC Prediction
eps = 0.1;
gamma = 0.9;
nEpisodes = 1e4;
MC = Montecarlo(eps, gamma, nEpisodes);

policy = randi(mygw.nActions, mygw.nStates, 1);
MC = MC.prediction(mygw, policy);

figure()
sgtitle('GridWorld - Montecarlo')
% Plot the policy
subplot(2, 1, 1)
title('PI - Optimal policy')
mygw.plotPolicy(MC.policy)
% Plot the value function
subplot(2, 1, 2)
title('PI - Optimal value function')
mygw.plotValue(MC.value)

%% MC Control
eps = 0.1;
gamma = 0.9;
nEpisodes = 1e4;
MC = Montecarlo(eps, gamma, nEpisodes);

policy = randi(mygw.nActions, mygw.nStates, 1);
MC = MC.control(mygw);

figure()
sgtitle('GridWorld - Montecarlo')
% Plot the policy
subplot(2, 1, 1)
title('PI - Optimal policy')
mygw.plotPolicy(MC.policy)
% Plot the value function
subplot(2, 1, 2)
title('PI - Optimal value function')
mygw.plotValue(MC.value)
