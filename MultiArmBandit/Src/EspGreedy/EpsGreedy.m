% ---------------------------------------- %
%  File: EpsGreedy.m                       %
%  Date: February 22, 2022                 %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Epsilon Greedy policy
classdef EpsGreedy < Policy

    properties
        % Eps-greedy params
        eps;    % Degree of exploration
        const;  % True if eps is constant, false otherwise
    end

    methods
        % Class constructor
        function obj = EpsGreedy(nArms, means, stdevs, stat, alpha, ...
                nIters, initEst, initEps, const)
            obj = obj@Policy(nArms, means, stdevs, stat, alpha, nIters, ...
                initEst)
            % Set params
            obj.eps = initEps * ones(1, nIters);
            obj.const = const;
        end

        % Choose the arm to pull with eps-greedy policy
        function arm = chooseArm(obj, iter)
            if (rand() < obj.eps(iter))
                % Explorative choice (prob = eps)
                arm = randi(obj.bandit.nArms, 1);
            else
                % Greedy choice (prob = 1-eps)
                [~, arm] = max(obj.meansEst(:, max(iter-1, 1)));
            end
        end

        % Update policy params
        function obj = updateParams(obj, iter, ~, ~)
            % Skip if it's the last iteration
            if (iter == obj.nIters)
                return;
            end
            % Update eps
            if (~obj.const)
                % Exponential decay:
                % dx/dt = -lambda*t -> x(t) = x(0) * e^(-lambda*t)
                % x(tbar) < 0.05 * x(0) -> lambda = ln(0.05) / tbar ~= 3 / tbar
                % Test:
                % t0 = 0; dt = 0.01; tf = 3; tbar = 1; t = t0:dt:tf; lambda = -log(0.05)/tbar;
                % x = @(t) exp(-lambda*t);
                % hold on; plot(t, x(t)); plot(t, x(tbar)*ones(size(t)), 'k-')
                obj.eps(iter+1) = obj.eps(1) * ...
                    exp((log(0.05) / (obj.nIters/3)) * iter);
            end
        end
    end
end
