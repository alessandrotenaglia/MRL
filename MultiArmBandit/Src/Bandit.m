% ---------------------------------------- %
%  File: Bandit.m                          %
%  Date: February 22, 2022                 %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Multi-Arm bandit
classdef Bandit

    properties
        % Bandit params
        nArms;  % Number of arms
        means;  % Means of the normal distributions for rewards
        stdevs; % Std devs of the normal distributions for rewards
        stat;   % True if the bandit is stationary, false otherwise
        rng;    % Local random number generator for reproducibility
    end

    methods
        % Class constructor
        function obj = Bandit(nArms, means, stdevs, stat)
            % Set properties of the bandit
            obj.nArms = nArms;
            obj.means = means;
            obj.stdevs = stdevs;
            obj.stat = stat;
            % Create a local random number generator
            obj.rng = RandStream('dsfmt19937', 'Seed', 42);
            % Why 42? It's the Answer to the Ultimate Question of Life,
            % The Universe, and Everything
        end

        % Pull an arm of the bandit
        function reward = pullArm(obj, arm)
            % Return a reward through a normal disribution:
            % N(mu, sigma^2) = sigma * N(0, 1) + mu
            % Test:
            % mu = 10; sigma = 5;
            % y = randn(1e6, 1);
            % z = sigma * y + mu;
            % stats = [mean(y) std(y) var(y); mean(z) std(z) var(z)]
            reward = obj.stdevs(arm) * randn(obj.rng, 1) + ...
                obj.means(arm);
        end

        % Update the bandit
        function obj = update(obj)
            if (~obj.stat)
                % Update the means
                obj.means = obj.means + randn(obj.rng, obj.nArms, 1) / 10;
            end
        end
    end
end
