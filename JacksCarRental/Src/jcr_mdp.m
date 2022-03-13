% ---------------------------------------- %
%  File: jcr_mdp.m                         %
%  Date: March 11, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

clear; close all; clc;

%%
maxCars = [20, 20];
maxMoves = 5;
gain = 10;
loss = 2;
lRet = [3, 2];
lRen = [3, 4];
jcr = JCR(maxCars, maxMoves, gain, loss, lRet, lRen);
jcr = jcr.generateP();
jcr = jcr.generateR();

%% Save
save JCR.mat jcr