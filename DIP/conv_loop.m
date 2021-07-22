function [output] = conv_loop(image, kernel, padType)
% Function to perform the convolution of a given image and kernel

image = double(image);   

% Size of the original image
picYsize = length(image(:,1));
picXsize = length(image(1,:));

% Size of the kernel
kerYsize = size(kernel, 1);
kerXsize = size(kernel, 2);

% Find amount of padding needed
padSize = [(kerYsize-1)/2, (kerXsize-1)/2];

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

% Loop through every row
for row = 1:picYsize
    % Loop through every column
    for col = 1:picXsize
        % Reset running result
        runningResult = 0;
        % Get the current window
        window = I(row:row+kerYsize-1, col:col+kerXsize-1);
        % Loop through the kernel rows
        for kernelRow = 1:kerYsize
            % Loop through the kernel columns
            for kernelCol = 1:kerXsize
                % Current kernel value
                kernelVal = kernel(kernelRow, kernelCol);
                % Current pixel
                pixelVal = window(kernelRow, kernelCol);
                % Mutiply current pixel with corresponding kernel value
                result = kernelVal * pixelVal;
                % Add result to running total
                runningResult = runningResult + result;  
            end
        end
        % Output the running result as the new pixel
        output(row,col) = runningResult;
    end
end
output = uint8(output);
end

