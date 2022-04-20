% ---------------------------------------- %
%  File: TempDiff.m                        %
%  Date: April 9, 2022                     %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Temporal Difference algorithms
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
                s = obj.env.initStates(randi(numel(obj.env.initStates)));
                % Choose the initial action using the epsilon-greedy method
                a = epsGreedy(obj, s);
                % Generate the episode
                while (~ismember(s, obj.env.obstStates) && ...
                        ~ismember(s, obj.env.termStates))
                    % Execute a step
                    [sp, r] = obj.env.step(s, a);
                    % Choose the next action using the epsilon-greedy
                    % method
                    ap = epsGreedy(obj, sp);
                    % Compute the new estimate based on the next state AND
                    % the next action 
                    % -> high variance
                    Qest = r + obj.gamma * obj.Q(sp, ap);
                    % Update the state-action value function
                    obj.Q(s, a) = obj.Q(s, a) + ...
                        obj.alpha * (Qest - obj.Q(s, a));
                    % Update the state value function and the policy
                    [obj.V(s), obj.pi(s)] = max(obj.Q(s, :));
                    % Set the state and the action for the next episode
                    s = sp;
                    a = ap;
                end
            end
        end

        % Expected-SARSA algorithm
        function obj = ESARSA(obj)
            % Iterate on episodes
            for e = 1 : obj.nEpisodes
                % Generate a randomic initial state
                s = obj.env.initStates(randi(numel(obj.env.initStates)));
                % Generate the episode
                while (~ismember(s, obj.env.obstStates) && ...
                        ~ismember(s, obj.env.termStates))
                    % Choose the action using the epsilon-greedy method
                    a = epsGreedy(obj, s);
                    % Execute a step
                    [sp, r] = obj.env.step(s, a);
                    % Compute the probability to choose the next action
                    probs = obj.eps / obj.env.nActions * ...
                        ones(obj.env.nActions, 1);
                    probs(obj.pi(sp)) = probs(obj.pi(sp)) + 1 - obj.eps;
                    % Compute the new estimate based on the expected reward
                    % of the next state 
                    % -> less variance than SARSA
                    Qest = r + obj.gamma * obj.Q(sp, :) * probs;
                    % Update the state-action value function
                    obj.Q(s, a) = obj.Q(s, a) + ...
                        obj.alpha * (Qest - obj.Q(s, a));
                    % Update the state value function and the policy
                    [obj.V(s), obj.pi(s)] = max(obj.Q(s, :));
                    % Set the state for the next episode
                    s = sp;
                end
            end
        end

        % Q-Learning algorithm
        function obj = Qlearning(obj)
            % Iterate on episodes
            for e = 1 : obj.nEpisodes
                % Generate a randomic initial state
                s = obj.env.initStates(randi(numel(obj.env.initStates)));
                % Generate the episode
                while (~ismember(s, obj.env.obstStates) && ...
                        ~ismember(s, obj.env.termStates))
                    % Choose the action using the epsilon-greedy method
                    a = epsGreedy(obj, s);
                    % Execute a step
                    [sp, r] = obj.env.step(s, a);
                    % Compute the new estimate based on the maximum of the
                    % state-action value function
                    % -> low variance, but nonzero bias
                    Qest = r + obj.gamma * max(obj.Q(sp, :));
                    % Update the state-action value function
                    obj.Q(s, a) = obj.Q(s, a) + ...
                        obj.alpha * (Qest - obj.Q(s, a));
                    % Update the state value function and the policy
                    [obj.V(s), obj.pi(s)] = max(obj.Q(s, :));
                    % Set the state for the next episode
                    s = sp;
                end
            end
        end

        % Double Q-Learning algorithm
        function obj = DQlearning(obj)
            % Initialize estimates
            Q1 = zeros(obj.env.nStates, obj.env.nActions);
            Q2 = zeros(obj.env.nStates, obj.env.nActions);
            % Iterate on episodes
            for e = 1 : obj.nEpisodes
                % Generate a randomic initial state
                s = obj.env.initStates(randi(numel(obj.env.initStates)));
                % Generate the episode
                while (~ismember(s, obj.env.obstStates) && ...
                        ~ismember(s, obj.env.termStates))
                    % Choose the action using the epsilon-greedy method
                    a = epsGreedy(obj, s);
                    % Execute a step
                    [sp, r] = obj.env.step(s, a);
                    % Choose the Q to update randomly 
                    % -> low variance and low bias
                    if (rand() < 0.5)
                        % Compute the new estimate based on the maximum of
                        % Q2
                        Qest = r + obj.gamma * max(Q2(sp, :));
                        % Update Q1
                        Q1(s, a) = Q1(s, a) + ...
                            obj.alpha * (Qest - Q1(s, a));
                    else
                        % Compute the new estimate based on the maximum of
                        % Q1
                        Qest = r + obj.gamma * max(Q1(sp, :));
                        % Update Q2
                        Q2(s, a) = Q2(s, a) + ...
                            obj.alpha * (Qest - Q2(s, a));
                    end
                    % Update Q using the average of Q1 and Q2
                    obj.Q(s, a) = 0.5 * (Q1(s, a) + Q2(s, a));
                    % Update the state value function and the policy
                    [obj.V(s), obj.pi(s)] = max(obj.Q(s, :));
                    % Set the state for the next episode
                    s = sp;
                end
            end
        end
    end
end
