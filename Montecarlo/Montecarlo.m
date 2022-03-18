% ---------------------------------------- %
%  File: Montecarlo.m                      %
%  Date: March 11, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Montecarlo
classdef Montecarlo

    properties
        eps;
        gamma;
        nEpisodes;
        policy;
        value;
    end

    methods
        % Class constructor
        function obj = Montecarlo(eps, gamma, nEpisodes)
            obj.eps = eps;
            obj.gamma = gamma;
            obj.nEpisodes = nEpisodes;
        end

        % Prediction
        function obj = prediction(obj, env, policy)
            %
            obj.value = zeros(env.nStates, 1);
            % Store the policy
            obj.policy = policy;
            % Initialize a counter
            N = zeros(env.nStates, 1);
            % Iterate on episodes
            for e = 1 : obj.nEpisodes
                % Genearte a randomic intial state (Exploring start)
                s0 = randi(env.nStates);
                % Run an episode
                [sts, ~, rews] = env.run(s0, policy, obj.eps);
                % Reset the cumulative reward
                G = 0;
                % Iterate backwards on the states of the episode
                for t = numel(sts)-2 : -1 : 1
                    % Update the cumulative reward
                    G = rews(t) + obj.gamma * G;
                    % Increment the counter
                    N(sts(t)) = N(sts(t)) + 1;
                    % Update the value function
                    obj.value(sts(t)) = obj.value(sts(t)) + ...
                        (1 / N(sts(t))) * (G - obj.value(sts(t)));
                end
            end
        end

        % Control
        function obj = control(obj, env)
            %
            obj.value = zeros(env.nStates, 1);
            % Generate a randomic intial policy
            obj.policy = randi(env.nActions, env.nStates, 1);
            % Initialize a counter
            N = zeros(env.nStates, env.nActions);
            % Initialize value-action function
            Q = zeros(env.nStates, env.nActions);
            % Iterate on episodes
            for e = 1 : obj.nEpisodes
                % Genearte a randomic intial state (Exploring start)
                s0 = randi(env.nStates);
                % Run an episode
                [sts, acts, rews] = env.run(s0, obj.policy, obj.eps);
                % Reset the cumulative reward
                G = 0;
                % Iterate backwards on the states of the episode
                for t = numel(sts)-2 : -1 : 1
                    % Update the cumulative reward
                    G = rews(t) + obj.gamma * G;
                    % Increment the counter
                    N(sts(t), acts(t)) = N(sts(t), acts(t)) + 1;
                    % Update the value-action function
                    Q(sts(t), acts(t)) = Q(sts(t), acts(t)) + ...
                        (1 / N(sts(t), acts(t))) * (G - Q(sts(t), acts(t)));
                    % Update the policy and the value fucntion
                    [obj.value(sts(t)), obj.policy(sts(t))] = ...
                        max(Q(sts(t), :));
                end
            end
        end
    end
end
