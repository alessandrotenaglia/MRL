% ---------------------------------------- %
%  File: Montecarlo.m                      %
%  Date: March 11, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Montecarlo
classdef Montecarlo

    properties
        env;        % Environment
        gamma;      % Discount factor
        nEpisodes;  % Number of episodes
        pi;         % Current policy
        V;          % Current state value function
        Q;          % Current state-action value function
        N;          % Number of actions
    end

    methods
        % Class constructor
        function obj = Montecarlo(env, gamma, nEpisodes)
            % Set properties
            obj.env = env;
            obj.gamma = gamma;
            obj.nEpisodes = nEpisodes;
            % Initialize arrays
            obj.pi = randi(env.nActions, env.nStates, 1);
            obj.V = zeros(env.nStates, 1);
            obj.Q = zeros(env.nStates, env.nActions);
            obj.N = zeros(env.nStates, env.nActions);
        end

        % Montecarlo Control Exploring start
        function obj = controlExploring(obj)
            % Iterate on episodes
            for e = 1 : obj.nEpisodes
                % Run an episode
                [sts, acts, rews] = obj.env.runExploring(0, obj.pi);
                % Update data with episode information
                obj = obj.update(sts, acts, rews);
            end
        end

        % Montecarlo Control Epsilon greedy
        function obj = controlEpsilon(obj, eps)
            % Iterate on episodes
            for e = 1 : obj.nEpisodes
                % Run an episode
                [sts, acts, rews] = obj.env.runEpsilon(0, obj.pi, eps);
                % Update data with episode information
                obj = obj.update(sts, acts, rews);
            end
        end

        % Montecarlo update with every-visit method
        function obj = update(obj, sts, acts, rews)
            % Reset the cumulative reward
            G = 0;
            % Iterate backwards on the states of the episode
            for t = numel(sts)-1 : -1 : 1
                % Update the cumulative reward
                G = rews(t) + obj.gamma * G;
                % Increment the counter
                obj.N(sts(t), acts(t)) = obj.N(sts(t), acts(t)) + 1;
                % Update the state-action value function
                obj.Q(sts(t), acts(t)) = obj.Q(sts(t), acts(t)) + ...
                    (1 / obj.N(sts(t), acts(t))) * ...
                    (G - obj.Q(sts(t), acts(t)));
                % Update the policy and the value function
                [obj.V(sts(t)), obj.pi(sts(t))] = ...
                    max(obj.Q(sts(t), :));
            end
        end
    end
end
