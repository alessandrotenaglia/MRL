% ---------------------------------------- %
%  File: WindyGridWorld.m                  %
%  Date: April 9, 2022                     %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Windy Grid World
classdef WindyGridWorld < MyGridWorld

    properties
        wind; % Wind
    end

    methods
        % Class constructor
        function obj = WindyGridWorld(nX, nY, moves, ...
                initCells, termCells, obstCells, wind)
            obj = obj@MyGridWorld(nX, nY, moves, ...
                initCells, termCells, obstCells);
            obj.wind = wind;
        end

        % Given a state and an action, compute the new position and the
        % reward
        function [sp, r] = step(obj, s, a)
            % Check the nature of the state
            if (ismember(s, obj.termStates))
                % If it's a terminal state, the state dosn't change and ...
                % the reward is 0
                sp = s;
                r = 0;
            elseif (ismember(s, obj.obstStates))
                % If it's an obstacle, the state doesn't change and ...
                % the reward is -1e6
                sp = s;
                r = -1e6;
            else
                % Convert the state in the corresponding position
                [x, y] = ind2sub([obj.nX, obj.nY], s);
                % Convert the action into axis movements
                [dx, dy] = obj.action2coord(a);
                % Compute new position
                xp = max(1, min(x + dx, obj.nX));
                yp = max(1, min(y + dy, obj.nY));
                % Convert the intermediate position in the
                % corresponding state
                sp = sub2ind([obj.nX, obj.nY], xp, yp);
                % Check the nature of the state
                if (ismember(sp, obj.obstStates))
                    % If it's an obstacle, the reward is -1e6
                    r = -1e6;
                else
                    % Compute new position after the action of the wind
                    yp = max(1, min(yp + obj.wind(xp), obj.nY));
                    % Convert the new position in the corresponding state
                    sp = sub2ind([obj.nX, obj.nY], xp, yp);
                    % Check the nature of the state
                    if (ismember(sp, obj.obstStates))
                        % If it's an obstacle, the reward is -1e6
                        r = -1e6;
                    else
                        % If it's not an obstacle, the reward is the ...
                        % distance traveled
                        r = -1;
                    end
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
            for i = 1 : numel(xs)
                t = text(xs(i)+0.5, 0.25, num2str(obj.wind(i)));
                set(t,'HorizontalAlignment','center','VerticalAlignment','middle')

            end
        end
    end
end
