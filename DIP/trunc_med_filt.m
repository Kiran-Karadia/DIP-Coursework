function [output] = trunc_med_filt(image,windowSize, padType)

% MATLAB is 1 indexed, values > 255 may be needed
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

% Set size of output
output = uint8(zeros(picYsize, picXsize));

% Get dimensions of the window
winYsize = windowSize(1);
winXsize = windowSize(2);
winColRadius = (winXsize - 1) / 2;

% Element index of median within histogram
th = ((winXsize*winYsize)-1)/2;

% Loop through each row in the image
for row = 1 : picYsize
    % Make a histogram of first window, find the median, and ltmdn
    [H, mdn, ltmdn] = first_hist_median(I, row, winYsize, winXsize, th);
    output(row, 1) = approx_mode(H, mdn);
    % Loop through the rest of the columns
    for col = 2 : picXsize
        % Put left col of previous window in leftCol
        leftCol = I(row:row+winYsize-1, col - 1);
        % Put right col of current window in rightCol
        rightCol = I(row:row+winYsize-1, col + (2*winColRadius));
        
        % Update histogram and ltmdn
        [H, ltmdn] = update_hist(H, mdn, winYsize, leftCol, rightCol, ltmdn); 
        % Find new median
        tempMdn = running_median(H, mdn, ltmdn, th); 
        output(row, col) = approx_mode(H, tempMdn);
    end
end
end


