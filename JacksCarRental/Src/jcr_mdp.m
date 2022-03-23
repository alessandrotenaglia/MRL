% ---------------------------------------- %
%  File: jcr_mdp.m                         %
%  Date: March 11, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%% Jack's Car Rental
maxCars = [20, 20];
maxMoves = 5;
gain = 10;
loss = 2;
lRet = [3, 3];
lRen = [3, 3];
jcr = JCR(maxCars, maxMoves, gain, loss, lRet, lRen);

%% MDP
% Generate the transition matrix
jcr = jcr.generateP();
% Generate the reward matrix
jcr = jcr.generateR();

%% Save JCR
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
save([path, '/JCR.mat'], 'jcr')
