% ---------------------------------------- %
%  File: Montecarlo.m                      %
%  Date: March 11, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Montecarlo
classdef MonteCarlo

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
        function obj = MonteCarlo(env, gamma, nEpisodes)
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
                % Set a randomic initial state
                sts = obj.env.initStates(randi(numel(obj.env.initStates)));
                % Initialize actions and rewards
                acts = [];
                rews = [];
                % Generate the episode
                while (~ismember(sts(end), obj.env.obstStates) && ...
                        ~ismember(sts(end), obj.env.termStates))
                    % Exploring start
                    if (isempty(acts))
                        % Choose the first action randomly
                        a = randi(obj.env.nActions);
                    else
                        % Choose the action following the policy
                        a = obj.pi(sts(end));
                    end
                    % Execute a step
                    [sp, r] = obj.env.step(sts(end), a);
                    % Store data
                    sts = [sts, sp];
                    acts = [acts, a];
                    rews = [rews, r];
                    % Detect loops and stop the episode to speed up ...
                    % the learning
                    if (ismember(sp, sts(1:end-1)))
                        rews(end) = -1e6;
                        break;
                    end
                end
                % Update data with episode information
                obj = obj.update(sts, acts, rews);
            end
        end

        % Montecarlo Control Epsilon greedy
        function obj = controlEpsilon(obj, eps)
            % Iterate on episodes
            for e = 1 : obj.nEpisodes
                % Set a randomic initial state
                sts = obj.env.initStates(randi(numel(obj.env.initStates)));
                % Initialize actions and rewards
                acts = [];
                rews = [];
                % Generate the episode
                while (~ismember(sts(end), obj.env.obstStates) && ...
                        ~ismember(sts(end), obj.env.termStates))
                    % Eps-greedy policy
                    if (rand() < eps)
                        % Explorative choice (prob = eps)
                        a = randi(obj.env.nActions);
                    else
                        % Greedy choice (prob = 1-eps)
                        a = obj.pi(sts(end));
                    end
                    % Execute a step
                    [sp, r] = obj.env.step(sts(end), a);
                    % Store data
                    sts = [sts, sp];
                    acts = [acts, a];
                    rews = [rews, r];
                    % Detect loops and stop the episode to speed up ...
                    % the learning
                    if (ismember(sp, sts(1:end-1)))
                        rews(end) = -1e6;
                        break;
                    end
                end
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
