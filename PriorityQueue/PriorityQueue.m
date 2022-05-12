% ---------------------------------------- %
%  File: PriorityQueue.m                   %
%  Date: May 12, 2022                      %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Priority Queue
classdef PriorityQueue
% PriorityQueue
%
% Example:
% dim = 1; PQ = PriorityQueue(dim)
% for i = 1 : 7; PQ = PQ.push(randi(10, dim, 1), i); end; PQ.elems
% [PQ, elem] = PQ.pop(); elem, PQ.elems

    properties
        dim;    % Dimension of elements
        nElems; % Number of elements
        elems;  % Elements
    end

    methods
        % Class constructor
        function obj = PriorityQueue(dim)
            % Set properties
            obj.dim = dim;
            % Initialize queue
            obj.nElems = 0;
            obj.elems = [];
        end

        % Push a new element into the queue
        function obj = push(obj, prio, elem)
            % Check the element size
            if (size(elem, 1) ~= obj.dim || size(elem, 2) ~= 1)
                disp('Error: invalid element size')
                return
            end
            % Increment the counter of elements
            obj.nElems = obj.nElems + 1;
            % Add the new element
            if (obj.nElems == 1)
                % If the queue is empty, the element is the first one
                obj.elems = [prio; elem];
            else
                % Find the index of the element with lower priority than
                % the new one
                index = find(obj.elems(1, :) > prio);
                if isempty(index)
                    % The new element has the lowest priority
                    obj.elems(:, obj.nElems) = [prio; elem];
                else
                    % Insert the new element in the correct position
                    obj.elems = [obj.elems(:, 1:index-1), [prio; elem], ...
                        obj.elems(:, index:end)];
                end
            end
        end

        % Pop the first element of the queue
        function [obj, elem] = pop(obj)
            % Save the first element
            elem = obj.elems(2:end, 1);
            % Decrease the counter of elements
            obj.nElems = obj.nElems - 1;
            % Remove the first element
            obj.elems(:, 1) = [];
        end

        % Check if the queue contains a specific element
        function [tf, index] = contains(obj, elem)
            % Check the element size
            if (size(elem, 1) ~= obj.dim || size(elem, 2) ~= 1)
                disp('Error: invalid element size')
                return
            end
            % Check if the queue contains the element
            [tf, index] = ismember(elem, obj.elems(2:end, :),'rows');
        end

        % Remove an element from the queue
        function obj = remove(obj, elem)
            % Check that the queue contains the element
            [tf, index] = obj.contains(elem);
            if (tf)
                % Remove the element from the queue
                obj.elems = [obj.elems(:, 1:index-1), ...
                    obj.elems(:, index+1:end)];
            end
        end

        % Clear the queue
        function obj = clear(obj)
            % Reset the counter
            obj.nElems = 0;
            % Clear the queue
            obj.elems = {};
        end
    end
end