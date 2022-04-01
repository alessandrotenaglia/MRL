% ---------------------------------------- %
%  File: Track.m                           %
%  Date: March 30, 2022                    %
%  Author: Alessandro Tenaglia             %
%  Email: alessandro.tenaglia@uniroma2.it  %
% ---------------------------------------- %

% Formula 1 track
classdef Track < MyGridWorld

    methods
        % Class constructor
        function obj = Track(nActions, cells)
            initCells = [];
            termCells = [];
            obstCells = [];
            for i = 1 : size(cells, 1)
                for j = 1 : size(cells, 2)
                    if (cells(i, j) == 2)
                        initCells = [initCells, [i; j]];
                    elseif (cells(i, j) == 3)
                        termCells = [termCells, [i; j]];
                    elseif (cells(i, j) == 1)
                        obstCells = [obstCells, [i; j]];
                    end
                end
            end
            obj = obj@MyGridWorld(size(cells, 1), size(cells, 2), ...
                nActions, initCells, termCells, obstCells);
        end
    end
    
end

