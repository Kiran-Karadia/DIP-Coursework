function [mode] = approx_mode(H, mdn)
% Approximate the mode by manipulation of local intensity histogram

% Check if there is a mode already, approximation is not needed
if length(find(H == max(unique(H)))) == 1
    mode = find(H == max(unique(H))) - 1;
else
    % Get all non-zero bins
    histIndices = find(H);
    % Difference between the median and smallest bin
    lowEndDiff = mdn - (histIndices(1)-1);
    % Difference between the median and largest bin
    highEndDiff = (histIndices(end)-1) - mdn;
    
    if (lowEndDiff < highEndDiff)
        % Distribution is skewed to the right
        truncatePoint = mdn + lowEndDiff + 1;
        H(truncatePoint:end) = 0;

        mode = med_hist_sort(H);
    else
        % Distribution is skewed to the left
        truncatePoint = highEndDiff - mdn + 1;
        H(1:truncatePoint) = 0;

        mode = med_hist_sort(H);
    end  
end
end

