% ---------------------------------------- %
%  File: TempDiffLambda.m                  %
%  Date: May 3, 2022                       %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Temporal Difference Lambda algorithms
classdef TempDiffLambda

    properties (Constant)
        SHOW = false;  % Flag to show plots
    end

    properties
        env;        % Environment
        alpha;      % Step size
        eps;        % Degree of exploration
        gamma;      % Discount factor
        lambda;     % Lambda factor
        nEpisodes;  % Number of episodes
        pi;         % Current policy
        V;          % Current state value function
        Q;          % Current state-action value function
    end

    methods
        % Class constructor
        function obj = TempDiffLambda(env, alpha, eps, gamma, lambda, ...
                nEpisodes)
            % Set properties
            obj.env = env;
            obj.alpha = alpha;
            obj.eps = eps;
            obj.gamma = gamma;
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
                % Environment subfigure
                ax1 = subplot(1, 2, 1);
                obj.env.plot(ax1);
                % Eligibility traces subfigure
                ax2 = subplot(1, 2, 2);
                xlabel(ax2, 'States'); ylabel(ax2, 'Actions');
            end
            % Iterate on episodes
            for e = 1 : obj.nEpisodes
                % Generate a randomic initial state
                s = obj.env.initStates(randi(numel(obj.env.initStates)));
                % Choose the initial action using the epsilon-greedy method
                a = epsGreedy(obj, s);
                % Initialize eligibility traces
                E = zeros(obj.env.nStates, obj.env.nActions);
                % Plot initial data
                if (obj.SHOW)
                    % Environment subfigure
                    sts = s;
                    rects = obj.env.plotPath(ax1, sts);
                    arrs = obj.env.plotPolicy(ax1, obj.pi);
                    % Eligibility traces subfigure
                    het = bar3(ax2, E);
                    for k = 1:length(het)
                        het(k).CData = het(k).ZData;
                        het(k).FaceColor = 'interp';
                    end
                    pause();
                end
                % Generate the episode
                while (~ismember(s, obj.env.obstStates) && ...
                        ~ismember(s, obj.env.termStates))
                    % Execute a step
                    [sp, r] = obj.env.step(s, a);
                    % Choose the next action using the epsilon-greedy
                    % method
                    ap = epsGreedy(obj, sp);
                    % Update the eligibility trace of the state-action pair
                    if (eleg == 1)
                        % Accumulating traces
                        E(s, a) = E(s, a) + 1;
                    elseif (eleg == 2)
                        % Replacing traces
                        E(s, a) = 1;
                    else
                        % Dutch traces
                        % alpha = 0 -> Accumulating traces
                        % alpha = 1 -> Replacing traces
                        E(s, a) = (1 - obj.alpha) * E(s, a) + 1;
                    end
                    % Compute the error based on the next state AND
                    % the next action
                    delta = r + obj.gamma * obj.Q(sp, ap) - obj.Q(s, a);
                    % Update the state-action value function
                    obj.Q = obj.Q + obj.alpha * delta * E;
                    % Update the state value function and the policy
                    [obj.V(s), obj.pi(s)] = max(obj.Q(s, :));
                    % Plot the episode step and the changes of the
                    % eligibilty traces
                    if (obj.SHOW)
                        % Environment subfigure
                        delete(rects); delete(arrs);
                        sts = [sts, s];
                        rects = obj.env.plotPath(ax1, sts);
                        arrs = obj.env.plotPolicy(ax1, obj.pi);
                        % Eligibility traces subfigure
                        het = bar3(ax2, E);
                        for k = 1:length(het)
                            het(k).CData = het(k).ZData;
                            het(k).FaceColor = 'interp';
                        end
                        pause();
                    end
                    % Set the state and the action for the next episode
                    s = sp;
                    a = ap;
                    % Decrement the eligibility traces
                    E = obj.gamma * obj.lambda * E;
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
                % Environment subfigure
                ax1 = subplot(1, 2, 1);
                obj.env.plot(ax1);
                % Eligibility traces subfigure
                ax2 = subplot(1, 2, 2);
                xlabel(ax2, 'States'); ylabel(ax2, 'Actions');
            end
            % Iterate on episodes
            for e = 1 : obj.nEpisodes
                % Generate a randomic initial state
                s = obj.env.initStates(randi(numel(obj.env.initStates)));
                % Choose the initial action using the epsilon-greedy method
                a = epsGreedy(obj, s);
                % Initialize eligibility traces
                E = zeros(obj.env.nStates, obj.env.nActions);
                % Plot initial data
                if (obj.SHOW)
                    % Environment subfigure
                    sts = s;
                    rects = obj.env.plotPath(ax1, sts);
                    arrs = obj.env.plotPolicy(ax1, obj.pi);
                    % Eligibility traces subfigure
                    het = bar3(ax2, E);
                    for k = 1:length(het)
                        het(k).CData = het(k).ZData;
                        het(k).FaceColor = 'interp';
                    end
                    pause();
                end
                % Generate the episode
                while (~ismember(s, obj.env.obstStates) && ...
                        ~ismember(s, obj.env.termStates))
                    % Execute a step
                    [sp, r] = obj.env.step(s, a);
                    % Choose the next action using the epsilon-greedy
                    % method
                    ap = epsGreedy(obj, sp);
                    % Update the eligibility traces
                    if (eleg == 1)
                        % Accumulating traces
                        E(s, a) = E(s, a) + 1;
                    elseif (eleg == 2)
                        % Replacing traces
                        E(s, a) = 1;
                    else
                        % Dutch traces
                        % alpha = 0 -> Accumulating traces
                        % alpha = 1 -> Replacing traces
                        E(s, a) = (1 - obj.alpha) * E(s, a) + 1;
                    end
                    % Compute the new estimate based on the next state AND
                    % the best action
                    [Qbest, abest] = max(obj.Q(sp, :));
                    delta = r + obj.gamma * Qbest - obj.Q(s, a);
                    % Update the state-action value function
                    obj.Q = obj.Q + obj.alpha * delta * E;
                    % Update the state value function and the policy
                    [obj.V(s), obj.pi(s)] = max(obj.Q(s, :));
                    % Plot the episode step and the changes of the
                    % eligibilty traces
                    if (obj.SHOW)
                        % Environment subfigure
                        delete(rects); delete(arrs);
                        sts = [sts, s];
                        rects = obj.env.plotPath(ax1, sts);
                        arrs = obj.env.plotPolicy(ax1, obj.pi);
                        % Eligibility traces subfigure
                        het = bar3(ax2, E);
                        for k = 1:length(het)
                            het(k).CData = het(k).ZData;
                            het(k).FaceColor = 'interp';
                        end
                        pause();
                    end
                    % Set the state and the action for the next episode
                    s = sp;
                    a = ap;
                    % Check if the next action is exploratory
                    if (ap == abest)
                        % Decrement the eligibility traces
                        E = obj.gamma * obj.lambda * E;
                    else
                        % Reset the eligibility traces
                        E = zeros(obj.env.nStates, obj.env.nActions);
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
