function [H, mdn, ltmdn] = first_hist_median(I, row, winYsize, winXsize, th)
% Make first hitogram of the current row
% Note: Image 'I' has been padded

% Empty histogram (256 for 8 bit image)
H = zeros(1,256);

% Position of median element within histogram
medianPos = th+1;

% Create histogram and put current window values in

% Loop through window row
for i = row:row+winYsize-1
    % Loop through window col 
    for j = 1:winXsize
        val = I(i,j);                   % Value to add
        outIndex = val + 1;             % Index is value is + 1
        H(outIndex) = H(outIndex) + 1;  % Increment frequency of bin
    end
end

% Calculate ltmdn
count = 0;
ltmdn = 0;
histIndex = 1;
% Check if median has been passed
while count <= medianPos
    % Count and add the number of pixel elements 
    count = count + H(histIndex);
    % If median value has not been passed, add to ltmdn
    if (ltmdn + H(histIndex) <= th)
        ltmdn = ltmdn + H(histIndex);
    end
    % Check if median position has been reached
    if count >= medianPos
        mdn = histIndex - 1;    % -1 due to MATLAB index starting at 1
        break
    end
    % Move up a bin
    histIndex = histIndex + 1;
end
end

