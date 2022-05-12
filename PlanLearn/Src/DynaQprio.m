% ---------------------------------------- %
%  File: DynaQprio.m                       %
%  Date: May 12, 2022                      %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Temporal Difference algorithms
classdef DynaQprio

    properties
        env;        % Environment
        alpha;      % Step size
        eps;        % Degree of exploration
        gamma;      % Discount factor
        theta;      % Treshold
        nEpisodes;  % Number of episodes
        pi;         % Current policy
        V;          % Current state value function
        Q;          % Current state-action value function
        P;          % Transition matrix
        R;          % Reward matrix
        I;          % Pairs
        PQ;         % Priority Queue
    end

    methods
        % Class constructor
        function obj = DynaQplus(env, alpha, eps, gamma, theta, nEpisodes)
            % Set properties
            obj.env = env;
            obj.alpha = alpha;
            obj.eps = eps;
            obj.gamma = gamma;
            obj.theta = theta;
            obj.nEpisodes = nEpisodes;
            % Initialize arrays
            obj.pi = randi(env.nActions, env.nStates, 1);
            obj.V = zeros(env.nStates, 1);
            obj.Q = zeros(env.nStates, env.nActions);
            obj.P = zeros(env.nStates, env.nActions);
            obj.R = zeros(env.nStates, env.nActions);
            obj.PQ = PriorityQueue(2);
            obj.ED = cell(env.nStates, 1);
        end

        % Choose the action using the epsilon-greedy method
        function a = epsGreedy(obj, s)
            if (rand() < obj.eps)
                % Explorative choice (prob = eps)
                a = randi(obj.env.nActions);
            else
                % Greedy choice (prob = 1-eps)
                [~, a] = obj.pi(s);
            end
        end

        % Dyna-Q Priorized algorithm
        function obj = dyna(obj)
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
                    % Update internal model
                    obj.P(s, a) = sp;
                    obj.R(s, a) = r;
                    % Add the edge
                    if (~ismember([s a], obj.I{sp}, 'rows'))
                        % Add the edge
                        obj.I{s} = [obj.I{s}; s a];
                    end
                    % 
                    prio = abs(r + obj.gamma * max(obj.Q(sp, :)) - obj.Q(s, a));
                    if (prio > obj.theta)
                        obj.PQ = obj.PQ.push(prio, [s; a]);
                    end
                    %
                    while (obj.PQ.nElems > 0)
                        pair = obj.PQ.pop();
                        sl = pair(1);
                        al = pair(2);
                        spl = obj.P(sl, al);
                        rl = obj.R(sl, al);
                        % Update the state-action value function using
                        % Q-learning algorithm
                        Qest = rl + obj.gamma * max(obj.Q(spl, :));
                        obj.Q(sl, al) = obj.Q(sl, al) + ...
                            obj.alpha * (Qest - obj.Q(sl, al));
                        %
                        pairs = obj.I{sl};
                        for p = 1 : size(pairs, 1)
                            spre = pairs(p, 1);
                            apre = pairs(p, 2);
                            rpre = obj.R(spre, apre);
                            %
                            prio = abs(rpre + obj.gamma * max(obj.Q(sl, :)) - obj.Q(spre, apre));
                            if (prio > obj.theta)
                                obj.PQ = obj.PQ.push(prio, [s; a]);
                            end
                        end
                    end
                    % Update the state value function and the policy
                    [obj.V(s), obj.pi(s)] = max(obj.Q(s, :));
                    % Set the state for the next episode
                    s = sp;
                end
            end
        end
    end
end
