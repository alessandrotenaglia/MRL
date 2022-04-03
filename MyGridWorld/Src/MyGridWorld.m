% ---------------------------------------- %
%  File: MyGridWorld.m                     %
%  Date: March 11, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% My Grid World
classdef MyGridWorld

    properties
        nX;         % Number of cells along x-axis
        nY;         % Number of cells along y-axis
        nActions;   % Number of actions
        nStates;    % Number of states
        initStates; % Initial states
        termStates; % Terminal states
        obstStates; % Obstacles states
        P;          % Transition matrix
        R;          % Reward matrix
    end

    methods
        % Class constructor
        function obj = MyGridWorld(nX, nY, moves, ...
                initCells, termCells, obstCells)
            % Set properties
            obj.nX = nX;
            obj.nY = nY;
            % Set the number of states
            obj.nStates = nX * nY;
            % Set the number of actions
            if (strcmpi(moves, 'kings'))
                obj.nActions = 8;
            else
                obj.nActions = 4;
            end
            % Convert the initial cells in states
            obj.initStates = sub2ind([nX, nY], ...
                initCells(1, :), initCells(2, :));
            % Convert the terminal cells in states
            obj.termStates = sub2ind([nX, nY], ...
                termCells(1, :), termCells(2, :));
            % Convert the obstacle cells in states
            if (size(obstCells, 2) >  0)
                obj.obstStates = sub2ind([nX, nY], ...
                    obstCells(1, :), obstCells(2, :));
            end
        end

        % Convert an action into axis movements
        function [dx, dy] = action2coord(~, a)
            if (a == 1)     % North
                dx = 0;
                dy = 1;
            elseif (a == 2) % South
                dx = 0;
                dy = -1;
            elseif (a == 3) % East
                dx = 1;
                dy = 0;
            elseif (a == 4) % West
                dx = -1;
                dy = 0;
            elseif (a == 5) % North-East
                dx = 1;
                dy = 1;
            elseif (a == 6) % North-West
                dx = -1;
                dy = 1;
            elseif (a == 7) % South-East
                dx = 1;
                dy = -1;
            elseif (a == 8) % South-West
                dx = -1;
                dy = -1;
            else            % Otherwise
                dx = 0;
                dy = 0;
            end
        end

        % Generate the transition matrix
        function obj = generateP(obj)
            % Initialize the matrix
            obj.P = zeros(obj.nStates, obj.nActions, obj.nStates);
            % Iterate on states
            for s = 1 : obj.nStates
                % Check the nature of the state
                if (ismember(s, obj.termStates) || ...
                        ismember(s, obj.obstStates))
                    % If it's a terminal state or an obstacle, ...
                    % it doesn't change for any action
                    for a = 1 : obj.nActions
                        obj.P(s, a, s) = 1;
                    end
                else
                    % Convert the state in cells
                    [x, y] = ind2sub([obj.nX, obj.nY], s);
                    % Iterate on actions
                    for a = 1 : obj.nActions
                        % Convert the action into axis movements
                        [dx, dy] = obj.action2coord(a);
                        % Set the new position
                        xp = max(1, min(x + dx, obj.nX));
                        yp = max(1, min(y + dy, obj.nY));
                        % Convert the new position in the corresponding
                        % state
                        sp = sub2ind([obj.nX, obj.nY], xp, yp);
                        % Set the transition P(s, a, s')
                        obj.P(s, a, sp) = 1;
                    end
                end
            end
        end

        % Generate the reward matrix
        function obj = generateR(obj)
            % Initialize the matrix
            obj.R = zeros(obj.nStates, obj.nActions);
            % Iterate on states
            for s = 1 : obj.nStates
                % Check the nature of the state
                if (ismember(s, obj.termStates))
                    obj.R(s, :) = 0;
                elseif (ismember(s, obj.obstStates))
                    obj.R(s, :) = -1e6;
                else
                    % Iterate on actions
                    for a = 1 : obj.nActions
                        % Convert the action into axis movements
                        [dx, dy] = obj.action2coord(a);
                        % The reward is equal to the distance traveled
                        obj.R(s, a) = -vecnorm([dx, dy]);
                    end
                end
            end
        end

        % Given a state and an action, compute the new position and the
        % reward
        function [sp, r] = move(obj, s, a)
            % Check the nature of the state
            if (ismember(s, obj.termStates))
                % If it's a terminal state, the reward is 0
                sp = s;
                r = 0;
            elseif (ismember(s, obj.obstStates))
                % If it's an obstacle, the reward is -1e6
                sp = s;
                r = -1e6;
            else
                % Convert the state in cells
                [x, y] = ind2sub([obj.nX, obj.nY], s);
                % Convert the action in cell movements
                [dx, dy] = obj.action2coord(a);
                % Compute new position
                xp = max(1, min(x + dx, obj.nX));
                yp = max(1, min(y + dy, obj.nY));
                % Convert the new position in the new state
                sp = sub2ind([obj.nX, obj.nY], xp, yp);
                % Check the nature of the state
                if (ismember(sp, obj.obstStates))
                    % If it's an obstacle, the reward is -1e6
                    r = -1e6;
                else
                    % If it's not an obstacle, the reward is the ...
                    % distance traveled
                    r = -vecnorm([dx, dy]);
                end
            end
        end

        % Run an episode following a determinitic policy
        function [sts, acts, rews] = run(obj, s0, policy)
            % Set initial state
            if (s0 == 0)
                % Generate a randomic initial state
                sts = obj.initStates(randi(numel(obj.initStates)));
            else
                % Set s0 as the initial state
                sts = s0;
            end
            % Initialize actions and rewards
            acts = [];
            rews = [];
            % Generate the episode
            while (~ismember(sts(end), obj.obstStates) && ...
                    ~ismember(sts(end), obj.termStates))
                % Choose action following the policy
                a = policy(sts(end));
                % Move on grid world
                [sp, r] = obj.move(sts(end), a);
                % Store the movement
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
        end

        % Run an episode with exploring start
        function [sts, acts, rews] = runExploring(obj, s0, policy)
            % Set initial state
            if (s0 == 0)
                % Generate a randomic initial state
                sts = obj.initStates(randi(numel(obj.initStates)));
            else
                % Set s0 as the initial state
                sts = s0;
            end
            % Initialize actions and rewards
            acts = [];
            rews = [];
            % Generate the episode
            while (~ismember(sts(end), obj.obstStates) && ...
                    ~ismember(sts(end), obj.termStates))
                % Exploring start
                if (isempty(acts))
                    % Choose the first action randomly
                    a = randi(obj.nActions);
                else
                    % Choose the action following the policy
                    a = policy(sts(end));
                end
                % Move on grid world
                [sp, r] = obj.move(sts(end), a);
                % Store the movement
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
        end

        % Run an episode following an eps-greedy policy
        function [sts, acts, rews] = runEpsilon(obj, s0, policy, eps)
            % Set initial state
            if (s0 == 0)
                % Generate a randomic initial state
                sts = obj.initStates(randi(numel(obj.initStates)));
            else
                % Set s0 as the initial state
                sts = s0;
            end
            % Initialize actions and rewards
            acts = [];
            rews = [];
            % Generate the episode
            while (~ismember(sts(end), obj.obstStates) && ...
                    ~ismember(sts(end), obj.termStates))
                % Eps-greedy policy
                if (rand() < eps)
                    % Explorative choice (prob = eps)
                    a = randi(obj.nActions);
                else
                    % Greedy choice (prob = 1-eps)
                    a = policy(sts(end));
                end
                % Move on grid world
                [sp, r] = obj.move(sts(end), a);
                % Store the movement
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
        end

        % Plot the grid world
        function plot(obj, ax)
            axis equal; hold on;
            ax.XTick = []; ax.YTick = [];
            ax.XTickLabel = []; ax.YTickLabel = [];
            ax.XLim = [0.5 obj.nX+0.5]; ax.YLim = [0.5 obj.nY+0.5];
            xs = 0.5 : 1 : obj.nX; ys = 0.5 : 1 : obj.nY;
            for i = 1 : numel(xs)
                for j = 1 : numel(ys)
                    r = rectangle(ax, 'Position', [xs(i) ys(j) 1 1]);
                    s = sub2ind([obj.nX, obj.nY], xs(i)+0.5, ys(j)+0.5);
                    if (ismember(s, obj.initStates))
                        r.FaceColor = 'c';
                    elseif (ismember(s, obj.obstStates))
                        r.FaceColor = 'k';
                    elseif (ismember(s, obj.termStates))
                        r.FaceColor = 'g';
                    end
                end
            end
        end

        % Plot the grid world with possible movements
        function arrs = plotGrid(obj, ax)
            arrs = [];
            xs = 0.5 : 1 : obj.nX; ys = 0.5 : 1 : obj.nY;
            for i = 1 : numel(xs)
                for j = 1 : numel(ys)
                    s = sub2ind([obj.nX, obj.nY], xs(i)+0.5, ys(j)+0.5);
                    if (~ismember(s, obj.obstStates) && ...
                            ~ismember(s, obj.termStates))
                        for a = 1 : obj.nActions
                            [dx, dy] = obj.action2coord(a);
                            arr = quiver(ax, xs(i)+0.5-dx*0.4, ...
                                ys(j)+0.5-dy*0.4, ...
                                dx*0.8, dy*0.8, 'k', ...
                                'AutoScale', 'off', ...
                                'MaxHeadSize', 0.5);
                            arrs = [arrs, arr];
                        end
                    end
                end
            end
        end

        % Plot a policy on the grid world
        function arrs = plotPolicy(obj, ax, policy)
            arrs = [];
            xs = 0.5 : 1 : obj.nX; ys = 0.5 : 1 : obj.nY;
            for i = 1 : numel(xs)
                for j = 1 : numel(ys)
                    s = sub2ind([obj.nX, obj.nY], xs(i)+0.5, ys(j)+0.5);
                    if (~ismember(s, obj.obstStates) && ...
                            ~ismember(s, obj.termStates))
                        [dx, dy] = obj.action2coord(policy(s));
                        arr = quiver(ax, xs(i)+0.5-dx*0.4, ...
                            ys(j)+0.5-dy*0.4, ...
                            dx*0.8, dy*0.8, 'k', ...
                            'AutoScale', 'off', ...
                            'MaxHeadSize', 0.5);
                        arrs = [arrs, arr];
                    end
                end
            end
        end

        % Plot a value function on the grid world
        function rects = plotPath(obj, ax, states)
            rects = [];
            alphas = linspace(0.25, 1, numel(states));
            for s = 1 : numel(states)
                [x, y] = ind2sub([obj.nX, obj.nY], states(s));
                r = rectangle(ax, ...
                    'Position', [x-0.25, y-0.25, 0.5, 0.5], ...
                    'Curvature',[1 1], ...
                    'FaceColor', [1, 0, 0, alphas(s)]);
                rects = [rects, r];
            end
        end
    end
end
