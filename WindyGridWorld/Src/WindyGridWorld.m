% ---------------------------------------- %
%  File: WindyGridWorld.m                  %
%  Date: April 9, 2022                     %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% My Grid World
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
        function [sp, r] = move(obj, s, a)
            % Check the nature of the state
            if (ismember(s, obj.termStates))
                % If it's a terminal state, the state dosn't change and ...
                % the reward is 0
                sp = s;
                r = 0;
            elseif (ismember(s, obj.obstStates))
                % If it's an obstacle, the state dosn't change and ...
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
                % Compute new position after the action of the wind
                xp = max(1, min(xp + obj.wind(xp, 1), obj.nX));
                yp = max(1, min(yp + obj.wind(yp, 2), obj.nY));
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
end
