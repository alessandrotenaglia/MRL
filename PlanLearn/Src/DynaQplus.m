% ---------------------------------------- %
%  File: DynaQplus.m                       %
%  Date: May 12, 2022                      %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Dyna-Q+ algorithm
classdef DynaQplus

    properties (Constant)
        SHOW = false;  % Flag to show plots
    end

    properties
        env;        % Environment
        alpha;      % Step size
        eps;        % Degree of exploration
        gamma;      % Discount factor
        k;          % Weight of uncertainty
        N;          % Number of planning loops
        nEpisodes;  % Number of episodes
        pi;         % Current policy
        V;          % Current state value function
        Q;          % Current state-action value function
        Pdet;       % Tansition matrix
        R;          % Reward matrix
        tau;        % Elapsed time counter
    end

    methods
        % Class constructor
        function obj = DynaQplus(env, alpha, eps, gamma, k, N, nEpisodes)
            % Set properties
            obj.env = env;
            obj.alpha = alpha;
            obj.eps = eps;
            obj.gamma = gamma;
            obj.k = k;
            obj.N = N;
            obj.nEpisodes = nEpisodes;
            % Initialize arrays
            obj.pi = randi(env.nActions, env.nStates, 1);
            obj.V = zeros(env.nStates, 1);
            obj.Q = zeros(env.nStates, env.nActions);
            obj.Pdet = zeros(env.nStates, env.nActions);
            obj.R = zeros(env.nStates, env.nActions);
            obj.tau = zeros(env.nStates, env.nActions);
        end

        % Choose the action using the epsilon-greedy method
        function a = epsGreedy(obj, s)
            if (rand() < obj.eps)
                % Explorative choice (prob = eps)
                a = randi(obj.env.nActions);
            else
                % Greedy choice (prob = 1-eps)
                [~, a] = max(obj.Q(s, :) + obj.k*sqrt(obj.tau(s,:)));
            end
        end

        % Dyna-Q+ algorithm
        function obj = dyna(obj)
            % SHOW: Create the figure
            if (obj.SHOW)
                figure();
                ax1 = subplot(1, 2, 1);
                obj.env.plot(ax1);
                ax2 = subplot(1, 2, 2);
                obj.env.plot(ax2);
            end
            % Iterate on episodes
            for e = 1 : obj.nEpisodes
                % Generate a randomic initial state
                s = obj.env.initStates(randi(numel(obj.env.initStates)));
                % SHOW: Plot initial data
                if (obj.SHOW)
                    sts = s;
                    rects1 = obj.env.plotPath(ax1, sts);
                    arrs1 = obj.env.plotPolicy(ax1, obj.pi);
                    arrs2 = obj.env.plotPolicy(ax2, obj.pi);
                end
                % Generate the episode
                while (~ismember(s, obj.env.obstStates) && ...
                        ~ismember(s, obj.env.termStates))
                    % Choose the action using the epsilon-greedy method
                    a = epsGreedy(obj, s);
                    % Execute a step
                    [sp, r] = obj.env.step(s, a);
                    % Update the state-action value function using
                    % Q-learning algorithm
                    Qest = r + obj.gamma * max(obj.Q(sp, :));
                    obj.Q(s, a) = obj.Q(s, a) + ...
                        obj.alpha * (Qest - obj.Q(s, a));
                    % Update the state value function and the policy
                    [obj.V(s), obj.pi(s)] = max(obj.Q(s, :));
                    % SHOW: Update the figure
                    if (obj.SHOW)
                        delete(rects1); delete(arrs1);
                        sts = [sts, sp];
                        rects1 = obj.env.plotPath(ax1, sts);
                        arrs1 = obj.env.plotPolicy(ax1, obj.pi);
                        pause(.1);
                    end
                    % Update internal model
                    obj.Pdet(s, a) = sp;
                    obj.R(s, a) = r;
                    % Increment non-visited pair
                    obj.tau = obj.tau + 1;
                    obj.tau(s, a) = 0;
                    % Planning loops
                    for it = 1 : obj.N
                        % Choose randomly a previously visited pair
                        [idxs, idxa] = find(obj.Pdet ~= 0);
                        rnd = randi(length(idxs));
                        sl = idxs(rnd);
                        al = idxa(rnd);
                        spl = obj.Pdet(sl, al);
                        rl = obj.R(sl, al);
                        % Update the state-action value function using
                        % Q-learning algorithm
                        Qest = rl + obj.gamma * max(obj.Q(spl, :));
                        obj.Q(sl, al) = obj.Q(sl, al) + ...
                            obj.alpha * (Qest - obj.Q(sl, al));
                        % Update the state value function and the policy
                        [obj.V(sl), obj.pi(sl)] = max(obj.Q(sl, :));
                        % SHOW: Update the figure
                        if (obj.SHOW)
                            delete(arrs2);
                            rects2 = obj.env.plotPath(ax2, [sl, spl]);
                            arrs2 = obj.env.plotPolicy(ax2, obj.pi);
                            drawnow;
                            delete(rects2)
                        end
                    end
                    % Set the state for the next episode
                    s = sp;
                end
                % SHOW: Clear the old episode
                if (obj.SHOW)
                    delete(rects1); delete(arrs1); delete(arrs2);
                end
            end
        end
    end
end
