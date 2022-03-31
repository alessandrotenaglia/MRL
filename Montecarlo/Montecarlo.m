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
        eps;        % Degree of exploration
        gamma;      % Discount factor
        nEpisodes;  % Number of episodes
        policy;     % Current policy
        value;      % Current state value function
        Q;          % Current state-action value function
        N;          % Number of actions
    end
    
    methods
        % Class constructor
        function obj = Montecarlo(env, eps, gamma, nEpisodes)
            % Set properties
            obj.env = env;
            obj.eps = eps;
            obj.gamma = gamma;
            obj.nEpisodes = nEpisodes;
            % Initialize arrays
            obj.policy = randi(env.nActions, env.nStates, 1);
            obj.value = zeros(env.nStates, 1);
            obj.Q = zeros(env.nStates, env.nActions);
            obj.N = zeros(env.nStates, env.nActions);
        end
        
        % Montecarlo Control
        function obj = control(obj)
            % Iterate on episodes
            fprintf('Episodes: %3d%%\n', 0);
            for e = 1 : obj.nEpisodes
                fprintf('\b\b\b\b%3.0f%%', (e / obj.nEpisodes) * 100);
                % Run an episode
                [sts, acts, rews] = obj.env.run(0, obj.policy, obj.eps);
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
                    % Update the policy and the value fucntion
                    [obj.value(sts(t)), obj.policy(sts(t))] = ...
                        max(obj.Q(sts(t), :));
                end
            end
            fprintf('\n');
        end
    end
end
