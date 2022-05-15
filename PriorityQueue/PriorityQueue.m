% +----------------------------------------+
% | File: PriorityQueue.m                  |
% | Date: May 10, 2022                     |
% | Author: Alessandro Tenaglia            |
% | Email: alessandro.tenaglia@uniroma2.it |
% +--------------------------------------- +
%
% PriorityQueue - a simple priority queue with methods of push, pop and
% contains.
%
% Example:
% dim = 1; PQ = PriorityQueue(dim);
% n = 5; prios = randperm(n); elems = 1:n;
% for i = 1 : n
%     fprintf("Pushing elem: %d with prio: %d\n", elems(i), prios(i));
%     PQ = PQ.push(prios(i), elems(i));
%     disp(PQ.elems);
% end
% elem = 1;
% fprintf("Checking if the elem: %d is in the queue... ", elem);
% [tf, index] = PQ.contains(elem);
% if (tf)
%     fprintf("yes at position: %d\n\n", index);
% else
%     fptinf("no\n\n")
% end
% elem = 7;
% fprintf("Checking if the elem: %d is in the queue... ", elem);
% [tf, index] = PQ.contains(elem);
% if (tf)
%     fprintf("yes at position: %d\n\n", index);
% else
%     fprintf("nope\n\n");
% end
% fprintf("Popping the first elem: %d\n", PQ.elems(1, 2));
% [PQ, elem] = PQ.pop();
% disp(PQ.elems);

classdef PriorityQueue

    properties
        dim;    % Dimension of elements
        nElems; % Number of elements
        elems;  % Elements
    end

    methods
        % Priority Queue class constructor.
        function obj = PriorityQueue(dim)
            % Check number of input arguments
            if (nargin == 0)
                % Set the default dimension
                obj.dim = 1;
            else
                % Set the dimension
                obj.dim = dim;
            end
            % Initialize queue
            obj = obj.clear();
        end

        % Pushes a new element into the queue with a specific priority.
        %
        % param prio: the priority to assign to the new element;
        % param elem: the element to push into the queue;
        %
        % return index: the index where the element is added;
        function [obj, index] = push(obj, prio, elem)
            % Check if the queue contains already the element
            [tf, index] = obj.contains(elem);
            if (tf)
                % Check if the element has already the desired priority
                if (obj.elems(index, 1) == prio)
                    return;
                end
                % Decrement the counter of elements
                obj.nElems = obj.nElems - 1;
                % Remove the element from the queue
                obj.elems = [obj.elems(1:index-1, :); ...
                    obj.elems(index+1:end, :)];
            end
            % Increment the counter of elements
            obj.nElems = obj.nElems + 1;
            % Add the new element
            if (obj.nElems == 1)
                % If the queue is empty, the element is the first one
                obj.elems = [prio elem];
            else
                % Find the index of the element with lower priority than
                % the new one
                index = find(obj.elems(:, 1) > prio);
                if isempty(index)
                    % The new element has the lowest priority
                    obj.elems(obj.nElems, :) = [prio elem];
                else
                    % Insert the new element in the correct position
                    obj.elems = [obj.elems(1:index-1, :); [prio elem]; ...
                        obj.elems(index:end, :)];
                end
            end
        end

        % Pops the first element of the queue.
        %
        % return elem: the element that has been removed
        function [obj, elem] = pop(obj)
            % Check the element dimension
            if (obj.nElems == 0)
                error('Error: the queue is empty.')
            end
            % Save the first element
            elem = obj.elems(1, 2:end);
            % Decrease the counter of elements
            obj.nElems = obj.nElems - 1;
            % Remove the first element
            obj.elems(1, :) = [];
        end

        % Checks if the queue contains a specific element.
        %
        % param elem: the element to search;
        %
        % return tf: true/false if the element is in the queue
        % return index: the index where the element is placed;
        function [tf, index] = contains(obj, elem)
            % Check the element dimension
            if (~all(size(elem) == [1, obj.dim]))
                error('Error: the element dimension is not valid.')
            end
            % Check if the queue is empty
            if obj.nElems == 0
                [tf, index] = deal(false, 0);
            else
                % Check if the queue contains the element
                [tf, index] = ismember(elem, obj.elems(:, 2:end), 'rows');
            end
        end

        % Clears the queue.
        function obj = clear(obj)
            % Reset the counter of elements
            obj.nElems = 0;
            % Clear all the elements
            obj.elems = [];
        end
    end
end