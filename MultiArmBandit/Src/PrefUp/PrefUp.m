% ---------------------------------------- %
%  File: PrefUp.m                          %
%  Date: February 22, 2022                 %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Preference Updates
classdef PrefUp < Policy

    properties
        % Preference Updates params
        prefs;  % Preference values of actions
        probs;  % Probability of choosing actions
    end

    methods
        % Class constructor
        function obj = PrefUp(nArms, means, stdevs, stat, alpha, ...
                nIters, initEst)
            obj = obj@Policy(nArms, means, stdevs, stat, alpha, ...
                nIters, initEst);
            % Set params
            obj.prefs = zeros(nArms, nIters);
            obj.probs = zeros(nArms, nIters);
            obj.probs(:, 1) = 1 / nArms;
        end

        % Choose the arm to pull with eps-greedy policy
        function arm = chooseArm(obj, iter)
            % Choose the action according to their probabilities
            % Test:
            % probs = [0.3, 0.1, 0.6]; y = zeros(size(probs)); nIters = 1e4
            % for i = 1 : nIters
            %  idx = find(rand() < cumsum(probs), 1, 'first');
            %  y(idx) = y(idx) + 1/nIters;
            % end
            arm = find(rand() < cumsum(obj.probs(:, iter)), 1, 'first');
        end

        % Update policy params
        function obj = updateParams(obj, iter, arm, reward)
            % Skip if it's the last iteration
            if (iter == obj.nIters)
                return
            end
            % Compute the step size for update
            if (obj.alpha == 0)
                step = 1 / obj.armCnt(arm);
            else
                step = obj.alpha;
            end
            % Update preferencies
            rew_diff = reward - obj.avgReward(iter);
            for i = 1:obj.bandit.nArms
                if (i == arm)
                    % H_a(k+1) = H_a(k) + alpha * (R − R_bar)(1 − pi_a(k)))
                    obj.prefs(i, iter+1) = obj.prefs(i, iter) + ...
                        step * rew_diff * (1 - obj.probs(i, iter));
                else
                    % H_a(k+1) = H_a(k) - alpha * (R − R_bar) * pi_a(k))
                    obj.prefs(i, iter+1) = obj.prefs(i, iter) - ...
                        step * rew_diff * obj.probs(i, iter);
                end
            end
            % Update probabilities
            exps = exp(obj.prefs(:, iter+1));
            obj.probs(:, iter+1) = exps / sum(exps);
        end
    end
end
