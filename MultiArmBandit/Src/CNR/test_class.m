%%
clear 
close all

% define input
input_file = 'Openness_model/input_CNR.xlsx';
output_file = 'Openness_model/Risultati/1905893_OUTPUTRisk.csv';
action_table = 'Openness_model/actionsTable.xlsx';
exec_file = 'Openness_model/OPENNESS_RomaTermini_v3AUTO_linux.sh';
dir_results = 'Openness_model/Risultati';
stat = 1;
nActs = 1;

% create input
b = Bandit_CNR(stat,...
               input_file,...
               exec_file,...
               dir_results,...
               action_table);

% generate random env
b.write_env;

% write action
b.write_act(1);

% run simulator
%b.run_simulation;

% get reward
%b.read_reward;

