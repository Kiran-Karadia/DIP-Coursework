function [H, ltmdn] = update_hist(H, mdn, winYsize, leftCol, rightCol, ltmdn)
% Remove values of leftCol from histogram
% Updates ltmdn if removed value is less than previous median ( minus 1)
% Remove values of rightCol from histogram
% Updates ltmdn if added value is less than previous median ( plus 1)

% H(val+1) is used since the histogram is 1 indexed. 0:255 -> H(1:256)
% e.g the bin with values of 42 are in H(43)

% Loop through length of windowYsize (number of rows)
for k = 1:winYsize
    val = double(leftCol(k));   % Get value to remove
    % H(val+1) due to histogram being 1 indexed
    val = double(val);
    H(val+1) = H(val+1) - 1;    % Remove value from histogram
    if (val < mdn)          
        ltmdn = ltmdn - 1;      % Decrement ltmdn
    end 

    val = double(rightCol(k));  % Get value to add
    H(val+1) = H(val+1) + 1;    % Add value from histogram
    if (val < mdn)              
        ltmdn = ltmdn + 1;      % Increment ltmdn
    end
end
end

