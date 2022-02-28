% ---------------------------------------- %
%  File: pref_up_run.m                     %
%  Date: 22 February 2022                  %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

function pref_up_run(nArms, means, stdevs, stat, alphas, nIters, initEst)

% Initilaize simulation data arrays
cnts = zeros(numel(alphas), nArms);
rews = zeros(numel(alphas), nIters);
real = zeros(numel(alphas), nArms, nIters);
ests = zeros(numel(alphas), nArms, nIters);
opts = zeros(numel(alphas), 1);

% Simulation
for a = 1:numel(alphas)
    pref = PrefUp(nArms, means, stdevs, stat, alphas(a), nIters, initEst);
    pref = pref.run();
    % Store data
    cnts(a, :) = pref.armCnt;
    rews(a, :) = pref.avgReward;
    real(a, :, :) = pref.meansReal;
    ests(a, :, :) = pref.meansEst;
    opts(a, 1) = pref.nOpt / nIters;
end


% Colors
colors = [[0 0.4470 0.7410];
    [0.8500 0.3250 0.0980];
    [0.4940 0.1840 0.5560];
    [0.9290 0.6940 0.1250];
    [0.4660 0.6740 0.1880];
    [0.3010 0.7450 0.9330];
    [0.6350 0.0780 0.1840]];

% Labels
alpha_lables = cell(size(alphas));
for a = 1:numel(alphas)
    if (alphas(a) == 0)
        alpha_lables{a} = '1/k';
    else
        alpha_lables{a} = num2str(alphas(a));
    end
end
arm_lables = cell(nArms, 1);
for i = 1:nArms
    arm_lables{i} = ['Arm #', num2str(i)];
end

% Plots
figure()
sgtitle('Preference Updates')
% Average rewards plot
subplot(1+nArms/2, 2, 1)
title('Average rewards')
hold on; grid on; legend;
for a = 1:numel(alphas)
    plot(1:nIters, squeeze(rews(a, :)), ...
        'Color', colors(a, :), ...
        'DisplayName', ['\alpha = ', alpha_lables{a}])
end
xlim([0, nIters]); xlabel('Iterations')
ylabel('Avg. rewards')
% Actions taken plot
subplot(1+nArms/2, 2, 2)
title('Actions taken')
hold on; grid on; legend;
pb = bar(categorical(arm_lables), squeeze(cnts)');
for a = 1:numel(alphas)
    pb(a).DisplayName = ['\alpha = ', alpha_lables{a}];
    pb(a).FaceColor = colors(a, :);
end
xlabel('Iterations')
ylabel('Actions taken')
% Real mean vs estimated means subplots
for i = 1:nArms
    subplot(1+nArms/2, 2, 2+i)
    title(['Arm #', num2str(i), ' Real vs Est means'])
    hold on; grid on; legend;
    plot(1:nIters, squeeze(real(1, i, :)), 'k', ...
        'DisplayName', 'Real')
    for a = 1:numel(alphas)
        plot(1:nIters, squeeze(ests(a, i, :)), ...
            'Color', colors(a, :), ...
            'DisplayName', ['\alpha = ', alpha_lables{a}])
    end
    xlabel('Iterations')
    ylabel('Means')
    xlim([0, nIters])
end

% Optimal actions frequency heatmap
figure()
h = heatmap('None', alpha_lables, opts);
h.Title = 'Percentages of optimal actions taken';
h.YLabel = 'Alphas';
h.ColorbarVisible = 'off';
end
