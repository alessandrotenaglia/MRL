% ---------------------------------------- %
%  File: Policy.m                          %
%  Date: 22 February 2022                  %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Abstarct class for policy
classdef (Abstract) Policy

    properties
        % Simulation params
        alpha;      % Step size for update
        bandit;     % Multi-arm bandit
        nIters;     % Number of iterations
        % Simulation data arrays
        armCnt;     % Counter of the actions taken
        avgReward;  % Average reward
        meansReal;  % Real value of means
        meansEst;   % Estimate of means
        nOpt;       % Number of optimal actions taken
    end

    methods
        % Class constructor
        function obj = Policy(nArms, means, stdevs, stat, alpha, ...
                nIters, initEst)
            % Set params
            obj.alpha = alpha;
            obj.bandit = Bandit(nArms, means, stdevs, stat);
            obj.nIters = nIters;
            % Init arrays to store simulation data
            obj.armCnt = zeros(nArms, 1);
            obj.avgReward = zeros(1, nIters);
            obj.meansReal = zeros(nArms, nIters);
            obj.meansEst = zeros(nArms, nIters);
            obj.meansEst(:, 1) = initEst;
            obj.nOpt = 0;
        end

        % Run an episode
        function obj = run(obj)
            % Iterate nIters times
            for iter = 1 : obj.nIters
                % Choose the arm to pull
                arm = obj.chooseArm(iter);
                % Get the reward
                reward = obj.bandit.pullArm(arm);
                % Store simluation data
                obj = obj.storeData(iter, arm, reward);
                % Update policy params
                obj = obj.updateParams(iter, arm, reward);
                % Update the bandit
                obj.bandit = obj.bandit.update();
            end
        end

        % Update model
        function obj = storeData(obj, iter, arm, reward)
            % Increment the counter of the action taken
            obj.armCnt(arm) = obj.armCnt(arm) + 1;
            % Update the average reward
            % R_avg(k) = R_avg(k-1) + 1/k * (R - R_avg(k-1))
            obj.avgReward(iter) = obj.avgReward(max(iter-1, 1)) + ...
                (1 / iter) * (reward - obj.avgReward(max(iter-1, 1)));
            % Store the real means
            obj.meansReal(:, iter) = obj.bandit.means;
            % Copy the means of the previous iteration
            obj.meansEst(:, iter) = obj.meansEst(:, max(iter-1, 1));
            % Update the mean of the chosen arm
            if (obj.alpha == 0)
                % Arithmetic average
                % Q_a(k) = Q_a(k-1) + 1/N_a(k) * (R - Q_a(k-1))
                obj.meansEst(arm, iter) = obj.meansEst(arm, iter) + ...
                    (1 / obj.armCnt(arm)) * (reward - obj.meansEst(arm, iter));
            else
                % Weighted avarege
                % Q_a(k) = Q_a(k-1) + alpha * (R - Q_a(k-1)) or
                % Q_a(k) = alpha * R + (1 - alpha) * Q_a(k-1)
                obj.meansEst(arm, iter) = obj.meansEst(arm, iter) + ...
                    obj.alpha * (reward - obj.meansEst(arm, iter));
            end
            % Check if it's the optimal action
            [~, opt_arm] = max(obj.meansReal(:, iter));
            if (arm == opt_arm)
                obj.nOpt = obj.nOpt + 1;
            end
        end
    end

    methods (Abstract)
        % Choose the arm to pull
        arm = chooseArm(obj, iter);
        % Update policy params
        obj = updateParams(obj, iter, arm, reward);
    end
end
