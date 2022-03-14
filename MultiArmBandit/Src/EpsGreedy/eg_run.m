% ---------------------------------------- %
%  File: eg_run.m                          %
%  Date: February 22, 2022                 %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

function eg_run(nArms, means, stdevs, stat, alphas, nIters, ...
    initEst, epsilons, epsconst)

% Initilaize simulation data arrays
cnts = zeros(numel(alphas), numel(epsilons), nArms);
rews = zeros(numel(alphas), numel(epsilons), nIters);
real = zeros(numel(alphas), numel(epsilons), nArms, nIters);
ests = zeros(numel(alphas), numel(epsilons), nArms, nIters);
opts = zeros(numel(alphas), numel(epsilons));

% Simulation
for a = 1:numel(alphas)
    for e = 1:numel(epsilons)
        eg = EpsGreedy(nArms, means, stdevs, stat, alphas(a), ...
            nIters, initEst, epsilons(e), epsconst(e));
        eg = eg.run();
        % Store data
        cnts(a, e, :) = eg.armCnt;
        rews(a, e, :) = eg.avgReward;
        real(a, e, :, :) = eg.meansReal;
        ests(a, e, :, :) = eg.meansEst;
        opts(a, e) = eg.nOpt / nIters;
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
eps_lables = cell(size(epsilons));
for e = 1:numel(epsilons)
    if (~epsconst(e))
        eps_lables{e} = [num2str(epsilons(e)), '*'];
    else
        eps_lables{e} = num2str(epsilons(e));
    end
end
arm_lables = cell(nArms, 1);
for i = 1:nArms
    arm_lables{i} = ['Arm #', num2str(i)];
end

% Plots
for a = 1:numel(alphas)
    figure()
    sgtitle(['\epsilon-greedy, \alpha = ', alpha_lables{a}])
    % Average rewards plot
    subplot(1+ceil(nArms/2), 2, 1)
    title('Average rewards')
    hold on; grid on; legend;
    for e = 1:numel(epsilons)
        plot(1:nIters, squeeze(rews(a, e, :)), ...
            'Color', colors(e, :), ...
            'LineWidth', 2, ...
            'DisplayName', ['\epsilon = ', eps_lables{e}])
    end
    xlabel('Iterations'); xlim([0, nIters]);
    ylabel('Avg. rewards');
    % Actions taken plot
    subplot(1+ceil(nArms/2), 2, 2)
    title('Actions taken')
    hold on; grid on; legend;
    pb = bar(categorical(arm_lables), squeeze(cnts(a, :, :))');
    for e = 1:numel(epsilons)
        pb(e).DisplayName = ['\epsilon = ', eps_lables{e}];
        pb(e).FaceColor = colors(e, :);
        text(pb(e).XEndPoints, pb(e).YEndPoints, string(pb(e).YData), ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'bottom')
    end
    xlabel('Iterations')
    ylabel('Actions taken')
    % Real mean vs estimated means subplots
    for i = 1:nArms
        subplot(1+ceil(nArms/2), 2, 2+i)
        title(['Arm #', num2str(i), ' Real vs Est means'])
        hold on;  grid on; legend;
        plot(1:nIters, squeeze(real(a, 1, i, :)), 'k', ... ...
            'LineWidth', 2, ...
            'DisplayName', 'Real')
        for e = 1:numel(epsilons)
            plot(1:nIters, squeeze(ests(a, e, i, :)), ...
                'Color', colors(e, :), ...
                'LineWidth', 2, ...
                'DisplayName', ['\epsilon = ', eps_lables{e}])
        end
        xlabel('Iterations'); xlim([0, nIters]);
        ylabel('Means');
    end
end
% Optimal actions frequency heatmap
figure()
h = heatmap(eps_lables, alpha_lables, opts);
h.Title = 'Percentages of optimal actions taken';
h.XLabel = 'Epsilons';
h.YLabel = 'Alphas';
h.ColorbarVisible = 'off';
end
