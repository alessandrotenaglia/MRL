% ---------------------------------------- %
%  File: Bandit.m                          %
%  Date: February 22, 2022                 %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Multi-Arm bandit
classdef Bandit_CNR < handle

    properties
        % Bandit params
        nActTypes;      % number of action types
        nActs;          % Number of actions        
        actValues;      % action values for each action type
        actNuples;      % matrix with all the Nuples for actions
        stat;           % True if the bandit is stationary, false otherwise
        rng;            % Local random number generator for reproducibility
        input_file;     % .csv file with env and act inputs
        output_file;    % .csv with the infection risk
        action_table;   % .csv with the actions to be taken
        device;         % localhost
        exec_file;      % executable file to run the simulation
        response;       % simulator response
        dir_results;    % results directory
        reward;         % simulation reward
        env;            % struct with current env
    end

    methods
        % Class constructor
        function obj = Bandit_CNR(stat, input_file, exec_file, dir_results, action_table)
            % Set properties of the bandit                      
            obj.stat = stat;
            % input file
            obj.input_file = input_file;           
            obj.dir_results = dir_results;
            % Create a local random number generator
            obj.rng = RandStream('dsfmt19937', 'Seed', 42);
            % Why 42? It's the Answer to the Ultimate Question of Life,
            % The Universe, and Everything
            obj.exec_file = exec_file;
            obj.response = 5;
            obj.reward = 5;
            % define action table
            obj.define_actiontable(action_table);
        end

        % define action table
        function obj = define_actiontable(obj,action_table)
            % get action table
            obj.action_table = readtable(action_table);
            % get action type
            obj.nActTypes = length(obj.action_table.variabile); 
            command = 'C = {';
            for action = 1:obj.nActTypes
                obj.actValues(action).val = str2num(obj.action_table.valore{action});
                command = [command, 'obj.actValues(',num2str(action),').val,'];
            end
            command(end) = [];
            command = [command, '};'];
            eval(command);
            D = C;
            [D{:}] = ndgrid(C{:});
            % get action nuples
            obj.actNuples = cell2mat(cellfun(@(m)m(:),D,'uni',0));
            % get number of ations
            obj.nActs = size(obj.actNuples,1);
        end

        % Get the reward
        function obj = read_reward(obj)
            % get the reward from STAM results
            T = readtable(obj.output_file);
            data = T.Variables;
            data = data(~isnan(data(:,2)),2);
            obj.reward = 1/mean(data);            
        end        

        % Set value in the environment
        function write_env(obj)
            % get the reward from STAM results
            Sheets = 2;
            for sheet = 1:Sheets
                % define env if empty
                obj.env(sheet).val = table();
                % read table and set env
                T = readtable(obj.input_file,'Sheet',sheet);
                Nvar = length(T.valore);
                for item = 1:Nvar
                    bounds = str2num(T.Commenti{item});                    
                    T.valore(item) = unifrnd(bounds(1),bounds(2));

                    areFloat = isempty(bounds(mod(bounds,1)==0));
                    if ~areFloat
                        T.valore(item) = floor(T.valore(item));
                    end                
                end
                obj.env(sheet).val = T;
                writetable(T,obj.input_file,'Sheet',sheet);
            end            
        end

        % Set value in the action
        function write_act(obj,actIndex)
            % select the action from the index
            act = obj.actNuples(actIndex,:);
            % write the action
            Sheets = 2;
            for action = 1:obj.nActTypes
                actname = obj.action_table.variabile{action};
                actval = act(action);
                for sheet = 1:Sheets                
                    Index = find(contains(obj.env(sheet).val.variabile,actname));
                    obj.env(sheet).val.valore(Index) = actval;
                    writetable(obj.env(sheet).val,obj.input_file,'Sheet',sheet);
                end
            end
            
        end

        % run simulation
        function obj = run_simulation(obj)
            command = strcat('mkdir ', {' '}, obj.dir_results);
            system(command{1});
            %obj.response = system(strcat('./',obj.exec_file));
            system(['cp Openness_model/dummyOutput.xlsx ', obj.dir_results, '/111_OUTPUTRisk.xlsx']);
            % get names in Risultati
            a = dir(obj.dir_results);
            pos = find(a(end).name == '_');
            number = a(end).name(1:pos-1);
            obj.output_file = strcat(obj.dir_results,'/',number,'_OUTPUTRisk.csv');
        end

        % Update the bandit
        function obj = update(obj)            
        end
    end
end
