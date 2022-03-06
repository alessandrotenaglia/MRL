% ---------------------------------------- %
%  File: up_conf_bound_run.m               %
%  Date: February 22, 2022                 %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

function up_conf_bound_run(nArms, means, stdevs, stat, alphas, ...
    nIters, initEst, cs)

% Initilaize simulation data arrays
cnts = zeros(numel(alphas), numel(cs), nArms);
rews = zeros(numel(alphas), numel(cs), nIters);
real = zeros(numel(alphas), numel(cs), nArms, nIters);
ests = zeros(numel(alphas), numel(cs), nArms, nIters);
opts = zeros(numel(alphas), numel(cs), 1);

% Simulation
for a = 1:numel(alphas)
    for c = 1:numel(cs)
        pref = UpConfBound(nArms, means, stdevs, stat, alphas(a), nIters, ...
            initEst, cs(c));
        pref = pref.run();
        % Store data
        cnts(a, c, :) = pref.armCnt;
        rews(a, c, :) = pref.avgReward;
        real(a, c, :, :) = pref.meansReal;
        ests(a, c, :, :) = pref.meansEst;
        opts(a, c) = pref.nOpt / nIters;
    end
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
c_lables = cell(size(cs));
for c = 1:numel(cs)
    c_lables{c} = num2str(cs(c));
end
arm_lables = cell(nArms, 1);
for i = 1:nArms
    arm_lables{i} = ['Arm #', num2str(i)];
end

% Plots
for a = 1:numel(alphas)
    figure()
    sgtitle(['Upper Confidence Bound, \alpha = ', alpha_lables{a}])
    % Average rewards plot
    subplot(1+nArms/2, 2, 1)
    title('Average rewards')
    hold on; grid on; legend;
    for c = 1:numel(cs)
        plot(1:nIters, squeeze(rews(a, c, :)), ...
            'Color', colors(c, :), ...
            'LineWidth', 2, ...
            'DisplayName', ['c = ', c_lables{c}])
    end
    xlabel('Iterations'); xlim([0, nIters]);
    ylabel('Avg. rewards');
    % Actions taken plot
    subplot(1+nArms/2, 2, 2)
    title('Actions taken')
    hold on; grid on; legend;
    pb = bar(categorical(arm_lables), squeeze(cnts(a, :, :))');
    for c = 1:numel(cs)
        pb(c).DisplayName = ['c = ', c_lables{c}];
        pb(c).FaceColor = colors(c, :);
        text(pb(c).XEndPoints, pb(c).YEndPoints, string(pb(c).YData), ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'bottom')
    end
    xlabel('Iterations')
    ylabel('Actions taken')
    % Real mean vs estimated means subplots
    for i = 1:nArms
        subplot(1+nArms/2, 2, 2+i)
        title(['Arm #', num2str(i), ' Real vs Est means'])
        hold on;  grid on; legend;
        plot(1:nIters, squeeze(real(a, 1, i, :)), 'k', ...
            'LineWidth', 2, ...
            'DisplayName', 'Real')
        for c = 1:numel(cs)
            plot(1:nIters, squeeze(ests(a, c, i, :)), ...
                'Color', colors(c, :), ...
                'LineWidth', 2, ...
                'DisplayName', ['c = ', num2str(cs(c))])
        end
        xlabel('Iterations'); xlim([0, nIters]);
        ylabel('Means');
    end
end
% Optimal actions frequency heatmap
figure()
h = heatmap(c_lables, alpha_lables, opts);
h.Title = 'Percentages of optimal actions taken';
h.XLabel = 'Cs';
h.YLabel = 'Alphas';
h.ColorbarVisible = 'off';
end
