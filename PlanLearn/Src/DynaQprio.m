% ---------------------------------------- %
%  File: DynaQprio.m                       %
%  Date: May 12, 2022                      %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Dyna-Q Priorized algorithm
classdef DynaQprio

    properties (Constant)
        SHOW = false;  % Flag to show plots
    end

    properties
        env;        % Environment
        alpha;      % Step size
        eps;        % Degree of exploration
        gamma;      % Discount factor
        theta;      % Threshold for prioritues
        nEpisodes;  % Number of episodes
        pi;         % Current policy
        V;          % Current state value function
        Q;          % Current state-action value function
        Pdet;       % Transition matrix
        R;          % Reward matrix
        I;          % Tranistion pairs
        PQ;         % Priority Queue
    end

    methods
        % Class constructor
        function obj = DynaQprio(env, alpha, eps, gamma, theta, nEpisodes)
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
            obj.Pdet = zeros(env.nStates, env.nActions);
            obj.R = zeros(env.nStates, env.nActions);
            obj.I = cell(env.nStates, 1);
            obj.PQ = PriorityQueue(2);
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

        % Dyna-Q Priorized algorithm
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
                    % Check if the pair is already stored
                    if (isempty(obj.I{sp}) || ...
                            ~ismember([s a], obj.I{sp}, 'rows'))
                        % Add the pair
                        obj.I{sp} = [obj.I{sp}; s a];
                    end
                    % Compute the pair priority as the QL error
                    prio = abs(r + obj.gamma * max(obj.Q(sp, :)) ...
                        - obj.Q(s, a));
                    % Check if the priority is higher than the threashold
                    if (prio > obj.theta)
                        % Add the pair to the priority queue
                        obj.PQ = obj.PQ.push(prio, [s a]);
                    end
                    % Iterate until the queue is empty
                    while (obj.PQ.nElems > 0)
                        % Pop the first element
                        [obj.PQ, ~, pair] = obj.PQ.pop();
                        sl = pair(1);
                        al = pair(2);
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
                        % Iterate on stored pairs
                        pairs = obj.I{sl};
                        for p = 1 : size(pairs, 1)
                            spre = pairs(p, 1);
                            apre = pairs(p, 2);
                            rpre = obj.R(spre, apre);
                            % Compute the pair priority as the QL error
                            prio = abs(rpre + obj.gamma * max(obj.Q(sl, :)) ...
                                - obj.Q(spre, apre));
                            % Check if the priority is higher than 
                            % the threashold
                            if (prio > obj.theta)
                                % Add the pair to the priority queue
                                obj.PQ = obj.PQ.push(prio, [spre apre]);
                            end
                        end
                    end
                    % Set the state for the next episode
                    s = sp;
                end
                % SHOW: Clear old episode
                if (obj.SHOW)
                    delete(rects1); delete(arrs1); delete(arrs2);
                end
            end
        end
    end
end
