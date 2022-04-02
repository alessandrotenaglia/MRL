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

%% MDP - P
% Generate the transition matrix
jcr = jcr.generateP();
% Check that transiions matrix are stochastic
% Sret = round(sum(jcr.Pret, 2), 3);
% for s = 1 : jcr.nStates
%     if (Sret(s) ~= 1)
%         disp("ERROR: Pret is not a stochastic matrix")
%     end
% end
% Sren = round(sum(jcr.Pren, 2), 3);
% for s = 1 : jcr.nStates
%     if (Sren(s) ~= 1)
%         disp("ERROR: Pren is not a stochastic matrix")
%     end
% end
% Smov = round(sum(jcr.Pmov, 3), 3);
% for s = 1 : jcr.nStates
%     if (Smov(s) ~= 1)
%         disp("ERROR: Pmov is not a stochastic matrix")
%     end
% end
S = round(sum(jcr.P, 3), 3);
for s = 1 : jcr.nStates
    for a = 1 : jcr.nActions
        if (S(s) ~= 1)
            disp("ERROR: P is not a stochastic matrix")
        end
    end
end

%% MDP - R
% Generate the reward matrix
jcr = jcr.generateR();

%% Save JCR
[path,~,~] = fileparts(which(matlab.desktop.editor.getActiveFilename));
save([path, '/../Data/JCR_MDP.mat'], 'jcr')
