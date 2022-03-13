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
        termStates; % Terminal states
        obstStates; % Ostacles states
        nStates;    % Number of states
        P;          % Transition matrix
        R;          % Reward matrix
    end

    methods
        % Class constructor
        function obj = MyGridWorld(nX, nY, nActions, termCells, obstCells)
            % Set properties
            obj.nX = nX;
            obj.nY = nY;
            % Check the number of actions
            if (nActions == 4 || nActions == 8)
                obj.nActions = nActions;
            else
                obj.nActions = 4;
            end
            % Convert the terminal cells in states
            obj.termStates = sub2ind([nX, nY], ...
                termCells(1, :), termCells(2, :));
            % Convert the obstacle cells in states
            if (size(obstCells, 2) >  0)
                obj.obstStates = sub2ind([nX, nY], ...
                    obstCells(1, :), obstCells(2, :));
            end
            % Set the number of states
            obj.nStates = nX * nY;
        end

        % Generate the transition matrix
        function obj = generateP(obj)
            % Initialize the matrix
            obj.P = zeros(obj.nStates, obj.nActions, obj.nStates);
            % Iterate on states
            for s = 1 : obj.nStates
                % Check the nature of the state
                if (ismember(s, obj.termStates))
                    % If it's a terminal state, it doesn't change for any
                    % action
                    obj.P(s, :, s) = 1;
                elseif (ismember(s, obj.obstStates))
                    % If it's an obstacle, it doesn't change for any action
                    obj.P(s, :, s) = 1;
                else
                    % Convert the state in cells
                    [x, y] = ind2sub([obj.nX, obj.nY], s);
                    % Iterate on actions
                    for a = 1 : obj.nActions
                        % Convert the action into axis movements
                        [dx, dy] = obj.action2coord(a);
                        % Set the new position
                        xp = max(1, min(obj.nX, x + dx));
                        yp = max(1, min(obj.nY, y + dy));
                        % Convert the new position in the new state
                        sp = sub2ind([obj.nX, obj.nY], xp, yp);
                        if (ismember(s, obj.obstStates))
                            % If it's an obstacle the state doesn't change
                            sp = s;
                        end
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
                    % If it's a terminal state, the reward is 0
                    obj.R(s, :) = 0;
                else
                    % If it's not a terminal state, the reward is -1
                    obj.R(s, :) = -1;
                end
            end
        end

        % Plot the grid world
        function plot(obj)
            axis equal; hold on;
            xlim([0.5 obj.nX+0.5])
            ylim([0.5 obj.nY+0.5])
            set(gca,'xtick',[]); set(gca,'ytick',[])
            set(gca,'xticklabel',[]); set(gca,'yticklabel',[])
            x = 0.5 : 1 : obj.nX;
            y = 0.5 : 1 : obj.nY;
            for i = 1 : numel(x)
                for j = 1 : numel(y)
                    r = rectangle('Position', [x(i) y(j) 1 1]);
                    s = sub2ind([obj.nX, obj.nY], x(i)+0.5, y(j)+0.5);
                    if (ismember(s, obj.obstStates))
                        r.FaceColor = 'k';
                    elseif (ismember(s, obj.termStates))
                        r.FaceColor = 'g';
                    else
                        for a = 1 : obj.nActions
                            [dx, dy] = obj.action2coord(a);
                            arr = annotation('arrow');
                            arr.Parent = gca;
                            arr.X = [x(i)+0.5-dx*0.45, x(i)+0.5+dx*0.45];
                            arr.Y = [y(j)+0.5-dy*0.45, y(j)+0.5+dy*0.45];
                        end
                    end
                end
            end
        end

        % Plot a policy on the grid world
        function plotPolicy(obj, policy)
            axis equal; hold on;
            xlim([0.5 obj.nX+0.5])
            ylim([0.5 obj.nY+0.5])
            set(gca,'xtick',[]); set(gca,'ytick',[])
            set(gca,'xticklabel',[]); set(gca,'yticklabel',[])
            x = 0.5 : 1 : obj.nX;
            y = 0.5 : 1 : obj.nY;
            for i = 1 : numel(x)
                for j = 1 : numel(y)
                    r = rectangle('Position', [x(i) y(j) 1 1]);
                    s = sub2ind([obj.nX, obj.nY], x(i)+0.5, y(j)+0.5);
                    if (~isempty(find(obj.obstStates == s, 1)))
                        r.FaceColor = 'k';
                    elseif (~isempty(find(obj.termStates == s, 1)))
                        r.FaceColor = 'g';
                    else
                        [dx, dy] = obj.action2coord(policy(s));
                        arr = annotation('arrow');
                        arr.Parent = gca;
                        arr.X = [x(i)+0.5-dx*0.4, x(i)+0.5+dx*0.4];
                        arr.Y = [y(j)+0.5-dy*0.4, y(j)+0.5+dy*0.4];
                    end
                end
            end
        end

        % Plot a value function on the grid world
        function plotValue(obj, value)
            axis equal; hold on;
            xlim([0.5 obj.nX+0.5])
            ylim([0.5 obj.nY+0.5])
            set(gca,'xtick',[]); set(gca,'ytick',[])
            set(gca,'xticklabel',[]); set(gca,'yticklabel',[])
            x = 0.5 : 1 : obj.nX;
            y = 0.5 : 1 : obj.nY;
            for i = 1 : numel(x)
                for j = 1 : numel(y)
                    r = rectangle('Position', [x(i) y(j) 1 1]);
                    s = sub2ind([obj.nX, obj.nY], x(i)+0.5, y(j)+0.5);
                    t = text(x(i)+0.5, y(j)+0.5, sprintf('%.2f', value(s)));
                    set(t, 'visible', 'on', ...
                        'HorizontalAlignment', 'center', ...
                        'VerticalAlignment', 'middle')
                    if (~isempty(find(obj.obstStates == s, 1)))
                        r.FaceColor = 'k';
                        t.Color = 'w';
                    elseif (~isempty(find(obj.termStates == s, 1)))
                        r.FaceColor = 'g';
                        t.Color = 'k';
                    else
                        t.Color = 'k';
                    end
                end
            end
        end

        % Convert an action into axis movements
        function [dx, dy] = action2coord(~, a)
            if (a == 1)     % North
                dx = 1;
                dy = 0;
            elseif (a == 2) % South
                dx = -1;
                dy = 0;
            elseif (a == 3) % East
                dx = 0;
                dy = 1;
            elseif (a == 4) % West
                dx = 0;
                dy = -1;
            elseif (a == 5) % North-East
                dx = 1;
                dy = 1;
            elseif (a == 6) % North-West
                dx = 1;
                dy = -1;
            elseif (a == 7) % South-East
                dx = -1;
                dy = 1;
            elseif (a == 8) % South-West
                dx = -1;
                dy = -1;
            end
        end
    end
end
