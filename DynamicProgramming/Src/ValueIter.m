% ---------------------------------------- %
%  File: ValueIter.m                       %
%  Date: March 11, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Dynamic Programming - Value Iteration
classdef ValueIter

    properties
        P;          % Transition matrix
        R;          % Reward matrix
        gamma;      % Discount factor
        tol;        % Tollerance
        nStates;    % Number of states
        nActions;   % Number of actions
        pi;         % Current policy
        V;          % Current state value function
    end

    methods
        % Class constructor
        function obj = ValueIter(P, R, gamma, tol)
            % Set properties
            obj.P = P;
            obj.R = R;
            obj.gamma = gamma;
            obj.tol = tol;
            % Set the number of states
            obj.nStates = size(P, 1);
            % Set the number of actions
            obj.nActions = size(P, 2);
            % Generate a randomic initial policy
            obj.pi = randi(obj.nActions, obj.nStates, 1);
            % Initialize the state value function
            obj.V = zeros(obj.nStates, 1);
        end

        % Value Iteration
        function obj = valueIter(obj)
            % Iterate until it's reached a fixed point
            while (1)
                % Store the old values to compute their variations
                oldValue = obj.V;
                % Iterate on states
                for s = 1 : obj.nStates
                    % Compute the state-action value function
                    Qpi = zeros(1, obj.nActions);
                    % Iterate on actions
                    for a = 1 : obj.nActions
                        % Compute the estimate
                        Qpi(a) = obj.R(s, a) + obj.gamma * ...
                            squeeze(obj.P(s, a, :))' * obj.V;
                    end
                    % Take the best action and its value
                    [obj.V(s), obj.pi(s)] = max(Qpi);
                end
                % Compute the max variation of the value function
                if (vecnorm(obj.V - oldValue, Inf) < obj.tol)
                    % If the max variation is less than the tollerance stop!
                    break;
                end
            end
        end
    end
end
