% ---------------------------------------- %
%  File: UpConfBound.m                     %
%  Date: February 22, 2022                 %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Upper Confident Bound
classdef UpConfBound < Policy

    properties
        % Upper Confident Bound params
        c;          % Degree of exploration
        uncerts;    % Values of uncertainty
    end

    methods
        % Class constructor
        function obj = UpConfBound(nArms, means, stdevs, stat, alpha, ...
                nIters, initEst, c)
            obj = obj@Policy(nArms, means, stdevs, stat, alpha, ...
                nIters, initEst);
            % Set params
            obj.c = c;
            obj.uncerts = Inf * ones(nArms, 1);
        end

        % Choose the arm to pull with upper confident bound policy
        function arm = chooseArm(obj, iter)
            [~, arm] = max(obj.meansEst(:, max(iter-1, 1)) + obj.uncerts);
        end

        % Update policy params
        function obj = updateParams(obj, iter, ~, ~)
            % Compute uncertainties
            % uncert = c * sqrt(ln(k) / N_a(k))
            for a = 1 : obj.bandit.nArms
                if (obj.armCnt(a) > 0)
                    obj.uncerts(a) = obj.c * ...
                        sqrt(log(iter) / obj.armCnt(a));
                end
            end
        end
    end
end
