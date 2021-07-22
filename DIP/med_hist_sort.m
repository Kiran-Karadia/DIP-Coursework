function [mdn] = med_hist_sort(H)
% Find the median of a histogram by counting up through the bins until the
% middle element is reached

% Find the element position within the histogram
mdnPos = floor(sum(sum(H))/2) + 1;
    
% Loop through all non-zero bins
histIndices = find(H);
count = 0;
for i = 1:length(histIndices)
    % Check if next bin will pass the median
    if count + H(histIndices(i)) >= mdnPos
        mdn = histIndices(i) - 1;
        break
    end
    count = count + H(histIndices(i));
end
end
