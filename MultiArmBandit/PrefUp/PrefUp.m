% ---------------------------------------- %
%  File: PrefUp.m                          %
%  Date: 22 February 2022                  %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Preference Updates
classdef PrefUp < Policy

    % Preference Updates params
    properties
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
        end

        % Choose the arm to pull with eps-greedy policy
        function arm = chooseArm(obj, iter)
            % Compute the probabilities to select the actions
            exps = exp(obj.prefs(:, iter));
            obj.probs(:, iter) = exps / sum(exps);
            % Choose the action according to their probabilities
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
                    obj.prefs(i, iter+1) = obj.prefs(i, iter) + ...
                        step * rew_diff * (1 - obj.probs(i, iter));
                else
                    obj.prefs(i, iter+1) = obj.prefs(i, iter) - ...
                        step * rew_diff * obj.probs(i, iter);
                end
            end
        end
    end
end
