% ---------------------------------------- %
%  File: JCR.m                             %
%  Date: March 11, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Jack's Car Rental
classdef JCR

    properties
        maxCars;    % Max number of cars in each location
        maxMoves;   % Max number of movable cars
        gain;       % Gain for each rented car
        loss;       % Loss for each moved car
        nStates;    % Number of states
        nActions;   % Number of actions
        lRet;       % Lambdas of returns
        lRen;       % Lambdas of rentals
        Pret;       % Transition matrix of returns
        Pren;       % Transition matrix of rentals
        Pmov;       % Transition matrix of moves
        P;          % Transition matrix
        R;          % Reward matrix
    end

    methods
        function obj = JCR(maxCars, maxMoves, gain, loss, lRet, lRen)
            % Set properties
            obj.maxCars = maxCars;
            obj.maxMoves = maxMoves;
            obj.gain = gain;
            obj.loss = loss;
            obj.lRet = lRet;
            obj.lRen = lRen;
            % Set number of states
            obj.nStates = (maxCars(1) + 1) * (maxCars(2) + 1);
            % Set number of actions
            obj.nActions = (2 * maxMoves) + 1;
        end

        % Generate transition matrix using the law of total probability
        function obj = generateP(obj)
            % Compute transition matrix of returns
            obj.Pret = obj.generatePret(1) * obj.generatePret(2);
            % Compute transition matrix of rentals
            obj.Pren = obj.generatePren(1) * obj.generatePren(2);
            % Compute transition matrix of moves
            obj.Pmov = obj.generatePmov();
            % Compute the transition matrix using the law of total
            % probability
            obj.P = zeros(obj.nStates, obj.nActions, obj.nStates);
            % Iterate on actions
            for a = 1 : obj.nActions
                % P(s, a, s') = Pren(s, s') * Pret(s, s') * Pmov(s, a, s')
                obj.P(:, a, :) = ...
                    obj.Pret * obj.Pren * squeeze(obj.Pmov(:, a, :));
            end
        end

        % Generate transition matrix of returns
        function P = generatePret(obj, loc)
            % Initilaize matrix
            P = zeros(obj.nStates, obj.nStates);
            % Iterate on states
            for s = 1 : obj.nStates
                % Convert the state in the car configuration
                cars = obj.state2cars(s);
                % Iterate on possible returns
                for n = 0 : obj.maxCars(loc)
                    % Set the new car configuration
                    newCars = cars;
                    newCars(loc) = min(newCars(loc) + n, obj.maxCars(loc));
                    % Compute the new state
                    sp = obj.cars2state(newCars);
                    % Set probability
                    P(s, sp) = P(s, sp) + poisspdf(n, obj.lRet(loc));
                end
            end
        end

        % Generate transition matrix of rentals
        function P = generatePren(obj, loc)
            % Initialize the matrix
            P = zeros(obj.nStates, obj.nStates);
            % Iterate on states
            for s = 1 : obj.nStates
                % Convert the state in the car configuration
                cars = obj.state2cars(s);
                for n = 0 : obj.maxCars(loc)
                    % Set the new car configuration
                    newCars = cars;
                    newCars(loc) = max(newCars(loc) - n, 0);
                    % Compute the new state
                    sp = obj.cars2state(newCars);
                    % Set probability
                    P(s, sp) = P(s, sp) + poisspdf(n, obj.lRen(loc));
                end
            end
        end

        % Generate transition matrix of moves
        function P = generatePmov(obj)
            % Initilaize matrix
            P = zeros(obj.nStates, obj.nActions, obj.nStates);
            % Iterate on states
            for s = 1 : obj.nStates
                % Convert the state in the car configuration
                cars = obj.state2cars(s);
                for a = 1 : obj.nActions
                    % Remap the action
                    moved = a - obj.maxMoves - 1;
                    % Compute how many cars it's really possible to move
                    if (moved >= 0)
                        % Cars are moved from location 2 to location 1
                        % It's not possible to move more cars than those
                        % available at location 2 and more than the free
                        % slots at location 1
                        moved = min([moved, cars(2), ...
                            obj.maxCars(1) - cars(1)]);
                    else
                        % Cars are moved from location 1 to location 2
                        % It's not possible to move more cars than those
                        % available at location 1 and more than the free
                        % slots at location 2
                        moved = -min([-moved, cars(1), ...
                            obj.maxCars(2) - cars(2)]);
                    end
                    % Compute the new number of cars in each location
                    newCars = cars + [moved; -moved];
                    % Compute the new state
                    sp = obj.cars2state(newCars);
                    % Set the transition
                    P(s, a, sp) = 1;
                end
            end
        end

        % Generate the reward matrix
        function obj = generateR(obj)
            % Compute the expected earning for ech state
            earnings = zeros(obj.nStates, 1);
            % Iterate on states
            for s = 1 : obj.nStates
                % Convert the state in the car configuration
                cars = obj.state2cars(s);
                % Available cars at location 1
                avail1 = 0:cars(1);
                % Probabilities to rent cars at loaction 1
                probs1 = poisspdf(avail1, obj.lRen(1));
                probs1(end) = 1 - sum(probs1(1:end-1));
                % Available cars at location 2
                avail2 = 0:cars(2);
                % Probabilities to rent cars at loaction 2
                probs2 = poisspdf(avail2, obj.lRen(2));
                probs2(end) = 1 - sum(probs2(1:end-1));
                % Compute the expected earning
                earnings(s) = obj.gain * avail1 * probs1' + ...
                    obj.gain * avail2 * probs2';
            end
            % Initialize reward matrix
            obj.R = zeros(obj.nStates, obj.nActions);
            % Iterate on actions
            for a = 1 : obj.nActions
                % Remap the action
                moved = a - obj.maxMoves - 1;
                % Set the expected reward
                obj.R(:, a) = obj.Pret * earnings - obj.loss * abs(moved);
            end
        end

        % Convert a state in the corresponding car configuration
        function cars = state2cars(obj, s)
            [carsA, carsB] = ind2sub(obj.maxCars + [1;1], s);
            cars = [carsA - 1; carsB - 1];
        end

        % Convert a car configuration in the corresponding state
        function s = cars2state(obj, cars)
            s = sub2ind(obj.maxCars + [1;1], cars(1) + 1, cars(2) + 1);
        end
    end
end
