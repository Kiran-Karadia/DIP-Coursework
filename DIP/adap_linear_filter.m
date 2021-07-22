function [output] = adap_linear_filter(image, windowSize, padType)
% Function to perform an adaptive linear filter
% The filter is an Unsharp masking filter X̂= x̄ + k(x - x̄)
% X̂= output value
% x̄= mean in window
% k = coefficient (controlled statistic, inversly propotional to SNR)

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

% Get dimensions of the window
winYsize = windowSize(1);
winXsize = windowSize(2);

% Set size of output
output = uint8(zeros(picYsize, picXsize));

% Create matrices for all k and xBar values
k = zeros(picYsize, picXsize);
xBar = zeros(picYsize, picXsize);

% Loop through every row
for row = 1:picYsize
    % Loop through every col
    for col = 1:picXsize
        % Get the current window
        window = I(row:row+winYsize-1, col:col+winXsize-1);
        % Find the mean of the current window
        xBar(row,col) = mean(window, 'all');
        % Find the standard deviation of the current window
        std = std2(window);
        % Calculate the signal-to-noise ratio
        snr = xBar(row,col)/std;
        % Calculate the coefficient k (inversly proportional to SNR)
        k(row,col) = 1/snr;
    end
end

% Normalise so k is always between 0 and 1
k = k / max(max(k));

% Loop through every row
for row = 1:picYsize
    % Loop through every col
    for col= 1:picXsize
        % Get the current pixel value
        x = image(row,col);
        % Calculate output pixel value
        output(row,col) = xBar(row,col) + k(row,col)*(x-xBar(row,col));
    end
end



