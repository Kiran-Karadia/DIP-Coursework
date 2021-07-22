function [output] = basic_convolution(image, kernel)

% Get dimensions of the image
imageRow = length(image(:,1));
imageCol = length(image(1,:));

% Get dimensions of the kernel
kerDim = [length(kernel(:,1)) , length(kernel(1,:))];

% Get kernel range to be used in for loop
% Loop iterates as if the centre of the kernel has coordinates (0,0)
kerRowRange = (kerDim(1)-1)/2;
kerColRange = (kerDim(2)-1)/2;

% Offset to get the relative position of the kernel value from the centre
% Since MATLAB cannot handle a negative index
rowOffset = (kerDim(1)+1)/2;
colOffset = (kerDim(2)+1)/2;

% Create matrix of zeros to allocate space for output image
output = zeros(imageRow, imageCol);

% Iterate through every pixel in the image
for currentRow = 1 : imageRow
    for currentCol = 1 : imageCol
        accumulator = 0;
        
        % Iterate through every element in the kernel
        for kerRow = -kerRowRange : kerRowRange
            for kerCol = -kerColRange : kerColRange
                
                % Check if filter falls outside of the image boundaries
                % (Essentially assuming zero outside of the image)
                if currentRow+kerRow >= 1 ...
                    && currentCol+kerCol >= 1 ...
                    && currentRow+kerRow <= imageRow ...
                    && currentCol+kerCol <= imageCol
                
                % Get value of the current pixel
                pixelValue = image(currentRow+kerRow, currentCol+kerCol);
                % Get value of the corresponding kernel element
                kernelValue = kernel(kerRow+rowOffset, kerCol+colOffset);
                
                result = pixelValue * kernelValue;
                accumulator = accumulator + result;
                end
            end
        end
        output(currentRow, currentCol) = accumulator;
    end
end

end

