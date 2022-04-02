% ---------------------------------------- %
%  File: PolicyIter.m                      %
%  Date: March 11, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Dynamic Programming - Policy Iteration
classdef PolicyIter

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
        function obj = PolicyIter(P, R, gamma, tol)
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

        % Policy Evaluation
        % Given a policy pi, estimate its value function v_pi
        function obj = policyEval(obj)
            % Initialize the state value function
            obj.V = zeros(obj.nStates, 1);
            % Iterate the evaluation, until it's reached a fixed point
            while (1)
                % Store the old values to compute their variations
                oldValue = obj.V;
                % Iterate on states
                for s = 1 : obj.nStates
                    % Update the estimates
                    obj.V(s) = obj.R(s, obj.pi(s)) + obj.gamma * ...
                        squeeze(obj.P(s, obj.pi(s), :))' * obj.V;
                end
                % Compute the max variation of the value function
                % Inf-norm: max{i}(|x_i|)
                % Test: vecnorm([0, -1, 2, -4], Inf)
                if (vecnorm(obj.V - oldValue, Inf) < obj.tol)
                    % If the max variation is less than the tollerance stop!
                    break;
                end
            end
        end

        % Policy Improvment
        % Given a policy pi, find a new policy pi' s.t v_pi' >= v_pi
        function obj = policyImprov(obj)
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
                % Take the best action
                [~, obj.pi(s)] = max(Qpi);
            end
        end

        % Policy Iteration
        function obj = policyIter(obj)
            % Iterate alternating policy evaluation and policy improvment
            % until it's reached a fixed point
            while (1)
                oldPolicy = obj.pi;
                % Policy evaluation: pi -> v_pi
                obj = obj.policyEval();
                % Policy improvment: pi -> pi' s.t. v_pi' >= v_pi
                obj = obj.policyImprov();
                % Check if the new policy is equal to the previous one
                if (vecnorm(obj.pi - oldPolicy, Inf) == 0)
                    % If the two policirs are equal stop!
                    break;
                end
            end
        end
    end
end
