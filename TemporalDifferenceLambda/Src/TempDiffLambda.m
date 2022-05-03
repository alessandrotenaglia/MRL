% ---------------------------------------- %
%  File: TempDiffLambda.m                  %
%  Date: May 3, 2022                       %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Temporal Difference algorithms
classdef TempDiffLambda

    properties (Constant)
        SHOW = true;
    end

    properties
        env;        % Environment
        alpha;      % Step size
        gamma;      % Discount factor
        eps;        % Degree of exploration
        lambda;     %
        nEpisodes;  % Number of episodes
        pi;         % Current policy
        V;          % Current state value function
        Q;          % Current state-action value function
    end

    methods
        % Class constructor
        function obj = TempDiffLambda(env, alpha, gamma, eps, lambda, ...
                nEpisodes)
            % Set properties
            obj.env = env;
            obj.alpha = alpha;
            obj.gamma = gamma;
            obj.eps = eps;
            obj.lambda = lambda;
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

        % SARSA Lambda algorithm
        function obj = SARSALambda(obj, eleg)
            % Create the figure
            if (obj.SHOW)
                figure();
                ax1 = subplot(1, 2, 1);
                obj.env.plot(ax1);
                ax2 = subplot(1, 2, 2);
            end
            % Iterate on episodes
            for e = 1 : obj.nEpisodes
                %
                E = zeros(obj.env.nStates, obj.env.nActions);
                % Generate a randomic initial state
                s = obj.env.initStates(randi(numel(obj.env.initStates)));
                % Choose the initial action using the epsilon-greedy method
                a = epsGreedy(obj, s);
                % Plot initial data
                if (obj.SHOW)
                    rects = obj.env.plotPath(ax1, s);
                    arrs = obj.env.plotPolicy(ax1, obj.pi);
                    sts = [];
                end
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
                    delta = r + obj.gamma * obj.Q(sp, ap) - obj.Q(s, a);
                    % Update the eligibility traces
                    E = obj.gamma * obj.lambda * E;
                    if (eleg == 1)
                        % Accumulating traces
                        E(s, a) = E(s, a) + 1;
                    elseif (eleg == 2)
                        % Replacing trace
                        E(s, a) = 1;
                    else
                        % Dutch trace
                        E(s, a) = (1 - obj.alpha) * E(s, a) + 1;
                    end
                    % Update the state-action value function
                    obj.Q = obj.Q + obj.alpha * delta * E;
                    % Update the state value function and the policy
                    [obj.V(s), obj.pi(s)] = max(obj.Q(s, :));
                    % Set the state and the action for the next episode
                    s = sp;
                    a = ap;
                    % Plot the episode step by step and the eligibilty
                    % traces
                    if (obj.SHOW)
                        delete(rects); delete(arrs);
                        sts = [sts, s];
                        rects = obj.env.plotPath(ax1, sts);
                        arrs = obj.env.plotPolicy(ax1, obj.pi);
                        hb = bar3(ax2, E);
                        for k = 1:length(hb)
                            zdata = hb(k).ZData;
                            hb(k).CData = zdata;
                            hb(k).FaceColor = 'interp';
                        end
                        drawnow;
                    end
                end
                % Clear old episode
                if (obj.SHOW)
                    delete(rects); delete(arrs);
                end
            end
        end

        % Q-Learning Lambda algorithm
        function obj = QLambda(obj, eleg)
            % Create the figure
            if (obj.SHOW)
                figure();
                ax1 = subplot(1, 2, 1);
                obj.env.plot(ax1);
                ax2 = subplot(1, 2, 2);
            end
            % Iterate on episodes
            for e = 1 : obj.nEpisodes
                %
                E = zeros(obj.env.nStates, obj.env.nActions);
                % Generate a randomic initial state
                s = obj.env.initStates(randi(numel(obj.env.initStates)));
                % Choose the action using the epsilon-greedy method
                a = epsGreedy(obj, s);
                % Plot initial data
                if (obj.SHOW)
                    rects = obj.env.plotPath(ax1, s);
                    arrs = obj.env.plotPolicy(ax1, obj.pi);
                    sts = [];
                end
                % Generate the episode
                while (~ismember(s, obj.env.obstStates) && ...
                        ~ismember(s, obj.env.termStates))
                    % Execute a step
                    [sp, r] = obj.env.step(s, a);
                    % Choose the next action using the epsilon-greedy
                    % method
                    ap = epsGreedy(obj, sp);
                    % Compute the new estimate based on the maximum of the
                    % state-action value function
                    [Qbest, abest] = max(obj.Q(sp, :));
                    delta = r + obj.gamma * Qbest - obj.Q(s, a);
                    % Update the eligibility traces
                    E = obj.gamma * E;
                    if (eleg == 1)
                        % Accumulating traces
                        E(s, a) = E(s, a) + 1;
                    elseif (eleg == 2)
                        % Replacing trace
                        E(s, a) = 1;
                    else
                        % Dutch trace
                        E(s, a) = (1 - obj.alpha) * E(s, a) + 1;
                    end
                    % Update the state-action value function
                    obj.Q = obj.Q + obj.alpha * delta * E;
                    % Update the state value function and the policy
                    [obj.V(s), obj.pi(s)] = max(obj.Q(s, :));
                    %
                    if (ap ~= abest)
                        %
                        E = zeros(obj.env.nStates, obj.env.nActions);
                    end
                    % Set the state and the action for the next episode
                    s = sp;
                    a = ap;
                    % Plot the episode step by step and the eligibilty
                    % traces
                    if (obj.SHOW)
                        delete(rects); delete(arrs);
                        sts = [sts, s];
                        rects = obj.env.plotPath(ax1, sts);
                        arrs = obj.env.plotPolicy(ax1, obj.pi);
                        hb = bar3(ax2, E);
                        for k = 1:length(hb)
                            zdata = hb(k).ZData;
                            hb(k).CData = zdata;
                            hb(k).FaceColor = 'interp';
                        end
                        drawnow;
                    end
                end
                % Clear old episode
                if (obj.SHOW)
                    delete(rects); delete(arrs);
                end
            end
        end
    end
end
