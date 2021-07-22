function [output] = adap_median_filt(image, windowSize, padType, centralWeight, constant)
% Adaptive median filter
% The median is found by using a histogram to store the current window
% values, each value is repeated by the calculated 'weights', and then 
% moving up through the histogram to find the median

image = double(image);   

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

% Allocate space for output
output = uint8(zeros(picYsize, picXsize)); 

% Number of window rows
winYsize = windowSize(1);
% Number of window columns
winXsize = windowSize(2);

% Allocate space for weights
weightWindow = zeros(winYsize, winXsize);

mdn = 0;

% Loop through every row in image
for row = 1:picYsize
    % Loop through every column in image
    for col = 1:picXsize
        % Get current window
        window = I(row:row+winYsize-1, col:col+winXsize-1);
        % Create empty histogram
        weightedWindowHist = zeros(1,256);
        % Loop through each row in current window
        for i = 1:winYsize
            % Loop through each column in current window
            for j = 1:winXsize
                % Calculate the distance from the centre of the window
                distance = sqrt((((winYsize+1)/2)-i)^2 + (((winXsize+1)/2)-j)^2);
                % Calculate the weight
                weightWindow(i,j) = round((centralWeight - (constant*distance*std(window(:))/mean(mean(window)))));
                % Put value and it's repetitions (weight) in the histogram
                weightedWindowHist(window(i,j)+1) = weightedWindowHist(window(i,j)+1) + weightWindow(i,j);
            end
        end
        % Element index in histogram of median
        medPos = floor( (sum(weightedWindowHist, 'all')/2) + 1);
        % Find indices of all non-zero bins
        histIndices = find(weightedWindowHist);
        % Running count to check if median position has been reached
        count = 0;
        % Loop through non-zero bins
        for k = 1:length(histIndices)
            % Check if median has been reached
            if count + weightedWindowHist(histIndices(k)) >= medPos
                % Median value is histogram index - 1
                mdn = histIndices(k) - 1;
                break
            end
            % Median has not been reached, add number of pixel elements
            count = count + weightedWindowHist(histIndices(k));
        end
        % Put median value into corresponding output pixel
        output(row, col) = mdn;
    end
end

