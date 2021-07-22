function [output] = order_statistics_filt(image, windowSize, padType, weights)
% Function to perform filtering using the general forumlation for an 
% Order Statistics filter.

% Size of the original image
picYsize = length(image(:,1));
picXsize = length(image(1,:));

% Find amount of padding needed
padSize = [((windowSize(1)-1) / 2), ((windowSize(2)-1) / 2)];

% Pad image
switch padType
    case {'zeros', 'zero', 'indexed'}
        I = padarray(image, padSize, 0);
    case 'symmetric'
        I = padarray(image, padSize, 'symmetric');
    otherwise
        msg = "Error in padType argument";
        error(msg)
end

% Set size of output
output = uint8(zeros(picYsize, picXsize));

% Get dimensions of the window
winYsize = windowSize(1);
winXsize = windowSize(2);

% Allocate space for window array
winArray = zeros(1,(winYsize*winXsize));

% Loop through every row
for row = 1:picYsize
    % Loop through every col
    for col = 1:picXsize
        % Reset counter for indexing winArray
        count = 1;
        % Loop through every row in window
        for winRow = row:row+winYsize-1
            % Loop through every col in window
            for winCol = col:col+winXsize-1
                % Put current value into winArray
                winArray(count) = I(winRow, winCol);
                count = count + 1;
            end
        end
        % Sort the window array in ascending order
        winArray = sort(winArray);
        % Multiply each element by corresponding weight
        winArray = winArray .* weights;
        % Sum the array
        pixelVal = sum(winArray);
        % Divide by sum of weights and output
        output(row,col) = pixelVal / sum(weights);
    end
end       
end

