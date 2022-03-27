% ---------------------------------------- %
%  File: mygw_main.m                        %
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
obstCells = [2, 2, 3; 2, 3, 3];
mygw = MyGridWorld(nX, nY, nActions, termCells, obstCells);

%% Plot Grid World
figure()
mygw.plotGrid();

%% Plot a randomic policy
policy = randi(mygw.nActions, mygw.nStates, 1);
figure()
mygw.plotPolicy(policy);

%% Plot a randomic episode
s0 = randi(mygw.nStates);

policy = randi(mygw.nActions, mygw.nStates, 1);
[sts, acts, rews] = mygw.run(s0, policy, 0.0);
figure()
mygw.plotPolicy(policy);
mygw.plotPath(sts);
