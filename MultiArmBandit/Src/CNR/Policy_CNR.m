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
        sim_data;   % structure with all the data from simulations
        iter;       % current iteration
    end

    methods
        % Class constructor
        function obj = Policy_CNR(stat, alpha, nIters, initEst, ...
                                  input_file, exec_file, dir_results, dir_storage, action_table)
            % Set params
            obj.alpha = alpha;
            obj.bandit = Bandit_CNR(stat, input_file, exec_file, dir_results, dir_storage, action_table);
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
            for iter = 1 : obj.nIters
                clc
                disp([num2str(iter),'/',num2str(obj.nIters)]);
                obj.iter = iter;
                try
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
                catch
                    iter = iter-1;
                end                
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

            %%% store data from simulation %%
            % get names in Risultati
            a = dir(obj.bandit.dir_results);
            pos = find(a(end).name == '_');
            number = a(end).name(1:pos-1);        
            % mask
            T = readtable(strcat(obj.bandit.dir_results,'/',number,'_OUTPUTMask.csv'));
            a = T.Variables;
            obj.sim_data.mask_no(:,obj.iter) = a(~isnan(a(:,2)),2);
            obj.sim_data.mask_surgical(:,obj.iter) = a(~isnan(a(:,3)),3);
            obj.sim_data.mask_ffp2(:,obj.iter) = a(~isnan(a(:,4)),4);
            % mask cumulata
            T = readtable(strcat(obj.bandit.dir_results,'/',number,'OUTPUTMaskCumulata.csv'));
            a = T.Variables;
            obj.sim_data.mask_no_cumul(:,obj.iter) = a(~isnan(a(:,2)),2);
            obj.sim_data.mask_surgical_cumul(:,obj.iter) = a(~isnan(a(:,3)),3);
            obj.sim_data.mask_ffp2_cumul(:,obj.iter) = a(~isnan(a(:,4)),4);
            % people
            T = readtable(strcat(obj.bandit.dir_results,'/',number,'_OUTPUTPeople.csv'));
            a = T.Variables;
            obj.sim_data.people_tot(:,obj.iter) = a(~isnan(a(:,2)),2);
            obj.sim_data.people_pos(:,obj.iter) = a(~isnan(a(:,3)),3);
            obj.sim_data.people_contact(:,obj.iter) = a(~isnan(a(:,4)),4);
            % people cumulata
            T = readtable(strcat(obj.bandit.dir_results,'/',number,'OUTPUTPeopleCumulata.csv'));
            a = T.Variables;
            obj.sim_data.people_tot_cumul(:,obj.iter) = a(~isnan(a(:,2)),2);
            obj.sim_data.people_pos_cumul(:,obj.iter) = a(~isnan(a(:,3)),3);
            obj.sim_data.people_contact_cumul(:,obj.iter) = a(~isnan(a(:,4)),4);
            % risk
            T = readtable(strcat(obj.bandit.dir_results,'/',number,'_OUTPUTRisk.csv'));
            a = T.Variables;
            obj.sim_data.risk(:,obj.iter) = a(~isnan(a(:,2)),2);
            % time
            obj.sim_data.time = a(~isnan(a(:,1)),1);
            % check mask and people            
            obj.sim_data.mask_tot(:,obj.iter) = obj.sim_data.mask_no(:,obj.iter) + obj.sim_data.mask_surgical(:,obj.iter) + obj.sim_data.mask_ffp2(:,obj.iter);

            % clear result directory
            store_dir = strcat(obj.bandit.dir_storage,'/',number,'/');
            command = strcat({'mkdir '}, store_dir);
            system(command{1});
            command = strcat({'mv'}, {' '}, obj.bandit.dir_results,{'/* '}, store_dir);
            system(command{1});
        end

        % plot data
        function obj = plot(obj,sim)
            % people
            figure(1);
            grid on
            hold on
            title('People')
            plot(obj.sim_data.time,obj.sim_data.people_tot(:,sim),'LineWidth',2);
            plot(obj.sim_data.time,obj.sim_data.people_pos(:,sim),'LineWidth',2);
            plot(obj.sim_data.time,obj.sim_data.people_contact(:,sim),'LineWidth',2);
            legend('tot','pos','contact')

            % people cumulate
            figure(2);
            grid on
            hold on
            title('People cumulate')
            plot(obj.sim_data.time,obj.sim_data.people_tot_cumul(:,sim),'LineWidth',2);
            plot(obj.sim_data.time,obj.sim_data.people_pos_cumul(:,sim),'LineWidth',2);
            plot(obj.sim_data.time,obj.sim_data.people_contact_cumul(:,sim),'LineWidth',2);
            legend('tot','pos','contact')

            % people
            figure(3);
            grid on
            hold on
            title('Mask')
            plot(obj.sim_data.time,obj.sim_data.mask_no(:,sim),'LineWidth',2);
            plot(obj.sim_data.time,obj.sim_data.mask_surgical(:,sim),'LineWidth',2);
            plot(obj.sim_data.time,obj.sim_data.mask_ffp2(:,sim),'LineWidth',2);
            legend('no','surgical','ffp2')

            % people cumulate
            figure(4);
            grid on
            hold on
            title('Mask cumulate')
            plot(obj.sim_data.time,obj.sim_data.mask_no_cumul(:,sim),'LineWidth',2);
            plot(obj.sim_data.time,obj.sim_data.mask_surgical_cumul(:,sim),'LineWidth',2);
            plot(obj.sim_data.time,obj.sim_data.mask_ffp2_cumul(:,sim),'LineWidth',2);
            legend('no','surgical','ffp2')

            % risk
            figure(5);
            grid on
            hold on
            title('Risk')
            plot(obj.sim_data.time,obj.sim_data.risk(:,sim),'LineWidth',2);

            % check mask and people
            figure(6)
            grid on
            hold on
            plot(obj.sim_data.time,obj.sim_data.people_tot(:,sim),'LineWidth',2);
            plot(obj.sim_data.time,obj.sim_data.mask_tot(:,sim),'LineWidth',2);
            legend('people tot','mask tot')

            
        end
    end

    methods (Abstract)
        % Choose the arm to pull
        arm = chooseAct(obj, iter);
        % Update policy params
        obj = updateParams(obj, iter, arm, reward);
    end
end
