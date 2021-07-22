function [newMdn] = running_median(H, mdn, ltmdn, th)
% Calculate the new median
% Start search at previous median and go either up or down the histogram
% depending on ltmdn

% Histogram is 1 indexed, value of median is in bin median + 1
bin = mdn + 1;                  % Start a previous median
if (ltmdn > th)                 % New median is smaller than before
    while 1
        bin = bin - 1;          % Go down a bin
        ltmdn = ltmdn - H(bin); % Minus frequency of bin
        if ltmdn <= th          % Break loop once median is reached
            break               
        end 
    end
else
    while ltmdn + H(bin) <= th  % Check if new median has been reached
        ltmdn = ltmdn + H(bin); % Add frequency of bin
        bin = bin + 1;          % Move up a bin
    end
end
newMdn = bin - 1;              % Bin - 1 since histogram is 1 indexed
end

