function [output] = weighted_median_filt(image, windowSize, padType, centreWeight)
% Function to perform weighted median filter with a given central weight
% Weights in this filter are the number of times a value should appear,
% rather than a multiply factor

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

% Make weights window
weights = ones(winYsize, winXsize);
% Put centre weight in the weights window
weights((winYsize+1)/2 ,(winXsize+1)/2) = centreWeight;

% Allocate space for window array
winArray = zeros(1,sum(weights,'all'));

% Transpose weights so indexing is row then column
% (Used during repetitions loop, incase of asymmetric window sizes)
weightsT = weights.';

% Loop through every row
for row = 1:picYsize
    % Loop through every col
    for col = 1:picXsize
        % Reset counter for indexing winArray
        count = 1;
        % Reset weights window index
        index = 1;
        % Loop through every row in window
        for winRow = row:row+winYsize-1
            % Loop through every col in window
            for winCol = col:col+winXsize-1
                % Put current value into winArray and repeat according to
                % corresponding weight
                for reps = 1:weightsT(index)
                    winArray(count) = I(winRow, winCol);
                    count = count + 1;
                end
                index = index + 1;
            end
        end
        winArray = sort(winArray);
        output(row,col) = median(winArray);
    end
end       
end

