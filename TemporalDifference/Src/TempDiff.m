% ---------------------------------------- %
%  File: TempDiff.m                        %
%  Date: April 9, 2022                     %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Montecarlo
classdef TempDiff

    properties
        env;        % Environment
        alpha;      % Step size
        eps;        % Degree of exploration
        gamma;      % Discount factor
        nEpisodes;  % Number of episodes
        pi;         % Current policy
        V;          % Current state value function
        Q;          % Current state-action value function
    end

    methods
        % Class constructor
        function obj = TempDiff(env, alpha, eps, gamma, nEpisodes)
            % Set properties
            obj.env = env;
            obj.alpha = alpha;
            obj.eps = eps;
            obj.gamma = gamma;
            obj.nEpisodes = nEpisodes;
            % Initialize arrays
            obj.pi = randi(env.nActions, env.nStates, 1);
            obj.V = zeros(env.nStates, 1);
            obj.Q = zeros(env.nStates, env.nActions);
        end

        % Choose the action using the epsilon-greedy method
        function a = epsGreedy(obj, s)
            if (rand() < obj.eps)
                % Explorative choice (prob = eps)
                a = randi(obj.env.nActions);
            else
                % Greedy choice (prob = 1-eps)
                a = obj.pi(s);
            end
        end

        % SARSA algorithm
        function obj = SARSA(obj)
            % Iterate on episodes
            for e = 1 : obj.nEpisodes
                % Generate a randomic initial state
                sts = obj.env.initStates(randi(numel(obj.env.initStates)));
                % Choose the initial action using the epsilon-greedy method
                a = epsGreedy(obj, sts);
                % Generate the episode
                while (~ismember(sts(end), obj.env.obstStates) && ...
                        ~ismember(sts(end), obj.env.termStates))
                    % Move on the grid world
                    [sp, r] = obj.env.move(sts(end), a);
                    % Choose the next action using the ...
                    % epsilon-greedy method
                    ap = epsGreedy(obj, sp);
                    % Update estimates and policy
                    Qp = obj.Q(sp, ap);
                    obj.Q(sts(end), a) = obj.Q(sts(end), a) + obj.alpha * ...
                        (r + obj.gamma * Qp - obj.Q(sts(end), a));
                    [obj.V(sts(end)), obj.pi(sts(end))] = max(obj.Q(sts(end), :));
                    % Set state and action for the next episode
                    sts = [sts, sp];
                    a = ap;
                end
            end
        end

        % Montecarlo Control Exploring start
        function obj = ESARSA(obj)
            % Iterate on episodes
            for e = 1 : obj.nEpisodes
                % Generate a randomic initial state
                sts = obj.env.initStates(randi(numel(obj.env.initStates)));
                % Generate the episode
                while (~ismember(sts(end), obj.env.obstStates) && ...
                        ~ismember(sts(end), obj.env.termStates))
                    % Choose the action using the epsilon-greedy method
                    a = epsGreedy(obj, sts(end));
                    % Move on the grid world
                    [sp, r] = obj.env.move(sts(end), a);
                    % Update estimates and policy
                    probs = obj.eps/obj.env.nActions * ones(obj.env.nActions, 1);
                    [~, amax] = max(obj.Q(sp, :));
                    probs(amax) = probs(amax) + 1 - obj.eps;
                    Qp = sum(obj.Q(sp, :) * probs);
                    obj.Q(sts(end), a) = obj.Q(sts(end), a) + obj.alpha * ...
                        (r + obj.gamma * Qp - obj.Q(sts(end), a));
                    [obj.V(sts(end)), obj.pi(sts(end))] = max(obj.Q(sts(end), :));
                    % Set state and action fo the enxt episode
                    sts = [sts, sp];
                end
            end
        end

        % Montecarlo Control Epsilon greedy
        function obj = Qlearning(obj)
            % Iterate on episodes
            for e = 1 : obj.nEpisodes
                % Generate a randomic initial state
                sts = obj.env.initStates(randi(numel(obj.env.initStates)));
                % Generate the episode
                while (~ismember(sts(end), obj.env.obstStates) && ...
                        ~ismember(sts(end), obj.env.termStates))
                    % Choose the action using the epsilon-greedy method
                    a = epsGreedy(obj, sts(end));
                    % Move on the grid world
                    [sp, r] = obj.env.move(sts(end), a);
                    % Update estimates and policy
                    Qp = max(obj.Q(sp, :));
                    obj.Q(sts(end), a) = obj.Q(sts(end), a) + obj.alpha * ...
                        (r + obj.gamma * Qp - obj.Q(sts(end), a));
                    [obj.V(sts(end)), obj.pi(sts(end))] = max(obj.Q(sts(end), :));
                    % Set state and action fo the enxt episode
                    sts = [sts, sp];
                end
            end
        end

        % Montecarlo Control Epsilon greedy
        function obj = DQlearning(obj)
            % Initialize estimates
            Q1 = zeros(obj.env.nStates, obj.env.nActions);
            Q2 = zeros(obj.env.nStates, obj.env.nActions);
            % Iterate on episodes
            for e = 1 : obj.nEpisodes
                % Generate a randomic initial state
                sts = obj.env.initStates(randi(numel(obj.env.initStates)));
                % Generate the episode
                while (~ismember(sts(end), obj.env.obstStates) && ...
                        ~ismember(sts(end), obj.env.termStates))
                    % Choose the action using the epsilon-greedy method
                    a = epsGreedy(obj, sts(end));
                    % Move on the grid world
                    [sp, r] = obj.env.move(sts(end), a);
                    % Choose the action using the epsilon-greedy
                    if (rand() < 0.5)
                        Qp = max(Q2(sp, :));
                        Q1(sts(end), a) = Q1(sts(end), a) + obj.alpha * ...
                            (r + obj.gamma * Qp - Q1(sts(end), a));
                    else
                        Qp = max(Q1(sp, :));
                        Q2(sts(end), a) = Q2(sts(end), a) + obj.alpha * ...
                            (r + obj.gamma * Qp - Q2(sts(end), a));
                    end
                    obj.Q(sts(end), a) = 0.5 * (Q1(sts(end), a) + Q2(sts(end), a));
                    [obj.V(sts(end)), obj.pi(sts(end))] = max(obj.Q(sts(end), :));
                    % Set state and action fo the enxt episode
                    sts = [sts, sp];
                end
            end
        end
    end
end
