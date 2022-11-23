% ---------------------------------------- %
%  File: Policy.m                          %
%  Date: February 22, 2022                 %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Abstarct class for policy
classdef (Abstract) Policy_CNR

    properties
        % Simulation params
        alpha;      % Step size for update
        bandit;     % Multi-arm bandit
        nIters;     % Number of iterations
        % Simulation data arrays
        actCnt;     % Counter of the actions taken
        avgReward;  % Average reward
        meansEst;   % Estimate of means
        nOpt;       % Number of optimal actions taken
    end

    methods
        % Class constructor
        function obj = Policy_CNR(stat, alpha, nIters, initEst, ...
                                  input_file, exec_file, dir_results, action_table)
            % Set params
            obj.alpha = alpha;
            obj.bandit = Bandit_CNR(stat, input_file, exec_file, dir_results, action_table);
            obj.nIters = nIters;
            % Init arrays to store simulation data
            obj.actCnt = zeros(obj.bandit.nActs, 1);
            obj.avgReward = zeros(1, nIters);            
            obj.meansEst = zeros(obj.bandit.nActs, nIters);
            obj.meansEst(:, 1) = initEst;
            obj.nOpt = 0;
        end

        % Run an episode
        function obj = run(obj)
            % Iterate nIters times
            disp('iterating...');
            for iter = 1 : obj.nIters
                % set the environment
                obj.bandit.write_env;
                % select action
                actIndex = obj.chooseAct(iter);
                % define the action
                obj.bandit.write_act(actIndex);
                % run the simulation
                obj.bandit = obj.bandit.run_simulation;
                % Get the reward
                obj.bandit = obj.bandit.read_reward;
                % Store simluation data
                obj = obj.storeData(iter, actIndex, obj.bandit.reward);
                % Update policy params
                obj = obj.updateParams(iter, actIndex, obj.bandit.reward);
            end
        end

        % Update model
        function obj = storeData(obj, iter, actIndex, reward)
            % Increment the counter of the action taken
            obj.actCnt(actIndex) = obj.actCnt(actIndex) + 1;
            % Update the average reward
            % R_avg(k) = R_avg(k-1) + 1/k * (R - R_avg(k-1))
            obj.avgReward(iter) = obj.avgReward(max(iter-1, 1)) + ...
                (1 / iter) * (reward - obj.avgReward(max(iter-1, 1)));            
            % Copy the means of the previous iteration
            obj.meansEst(:, iter) = obj.meansEst(:, max(iter-1, 1));
            % Update the mean of the chosen arm
            if (obj.alpha == 0)
                % Arithmetic average
                % Q_a(k) = Q_a(k-1) + 1/N_a(k) * (R - Q_a(k-1))
                obj.meansEst(actIndex, iter) = obj.meansEst(actIndex, iter) + ...
                    (1 / obj.actCnt(actIndex)) * (reward - obj.meansEst(actIndex, iter));
            else
                % Weighted avarege
                % Q_a(k) = Q_a(k-1) + alpha * (R - Q_a(k-1)) or
                % Q_a(k) = alpha * R + (1 - alpha) * Q_a(k-1)
                obj.meansEst(actIndex, iter) = obj.meansEst(actIndex, iter) + ...
                    obj.alpha * (reward - obj.meansEst(actIndex, iter));
            end            
        end
    end

    methods (Abstract)
        % Choose the arm to pull
        arm = chooseAct(obj, iter);
        % Update policy params
        obj = updateParams(obj, iter, arm, reward);
    end
end
