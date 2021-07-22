function [output] = conv_fft(image,kernel, padType)
% Function to perform the convolution of a given image and kernel using the
% Fast-Fourier Transform method
image = double(image);

% Rotate the kernel 90 degrees - incase of assymetric kernels
kernel = rot90(kernel, 2);

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


% Fft of the input image
fftImage = fft2(I);

% Fft of kernel (padded to be the same size as I)
fftKernel = fft2(kernel, size(I,1), size(I,2));

% Multiply and inverse
output = ifft2(fftImage .* fftKernel);

% Remove padding to get back to original size
output = output(kerYsize:end, kerXsize:end);

output = uint8(output);
end

