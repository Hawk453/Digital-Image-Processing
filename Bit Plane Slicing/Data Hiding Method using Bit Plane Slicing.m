% Task 3: Data Hiding Method using Bit Plane Slicing

clear variables; %clearing workspace
close all;  %clear folder

im = imread('lena.bmp'); % reading the image
figure(1); % Create figure window
imshow(im)% Display Original Image
title('Original Image');%Add title
    [m, n, o] = size(im);%return row vector whose elements are the lengths
    %of the corresponding dimensions of im
figure(2); imshow(im(:,:,1)); title('Red Plane'); % Red Plane
figure(3); imshow(im(:,:,2)); title('Green Plane'); % Green Plane 
figure(4); imshow(im(:,:,3)); title('Blue Plane'); % Blue Plane

%%%%%%%%% Bit Plane Slicing of Red Plane %%%%%%%%%%%%%%%%%%%%%%%

    R(:,:) = im(:,:,1); %Red Plane
for i = 1:m %rows
    for j=1:n %columns
        for k=1:8 %8 bit planes on the gray scale
            bitplanesR(i, j, k) = bitget(im(i, j, 1), k);%return bit value
        end
    end
end

for i=1:8
    figure(5);%Create figure window
    subplot(2, 4, i);%Create axes in tiled positions
    titleString = 'bit planes(RED PLANE)';%title
    imagesc(uint8(bitplanesR(:,:,i))); %Display image with scaled colors
    axis equal;%sets the aspect ratio so that the data units are the same 
    %in every direction
    colormap(gray);%sets the colormap for the figure to gray 
    title([titleString int2str(i-1)]);%Add title
end

bitplanesR(:,:,1) =0;
bitplanesR(:,:,2) =0;

for i=1:8
    figure(6);%Create figure window
    subplot(2, 4, i);%Create axes in tiled positions
    titleString = 'bit planes(RED PLANE)';%title
    imagesc(uint8(bitplanesR(:,:,i))); %Display image with scaled colors
    axis equal;%sets the aspect ratio so that data units are same in every
    %direction
    colormap(gray);%sets the colormap for the figure to gray 
    title([titleString int2str(i-1)]);%Add title
end
%%%%%%Recovering Red Plane%%%%%%%%%%%%%
b1 = zeros(m,n); %Create array of all zeros
b1(:,:) = 0;

for i = 1:m %rows 
    for j = 1:n %columns
        for k = 1:8 %8 bit planes on the gray scale
            b1(i,j) = b1(i,j) + bitplanesR(i,j,k)*(2^(k-1));
            %restoration of bit values, to recover the red plane
        end
    end
end

figure(7);%Create figure window
imshow(uint8(b1));%Display Recovered Red Plane
title('Recovered Red Plane');%Add title
b1 = uint8(b1); %converts the vector b1 into an unsigned integer

%%%%%%%%%%%%%%%%%%%%% Result and Analysis %%%%%%%%%%%%%%%%%%%%%%%
% The structural similarity index measure (SSIM)
% S = ssim(b1, R)
% S = 0.9915

% Peak Signal-to-Noise Ratio
% P = psnr(b1, R)
% P = 42.6990

% Conclusion 
% An image that has less MSE value is more preferable for transfer of the secret text.
% RMSE measures the average magnitude of the error.
% PSNR is usually expressed in terms of the logarithmic decibel scale.
% It is the square of ratio of maximum pixel value i.e. 255
% to the MSE value. Images having high PSNR value are preferable.
% For a good image the SNR value must be high.
% SSIM is used to measure the quality by capturing the
% similarity of images based on three comparisons: luminance, contrast and
% structure which are selected for the measure of imperceptibility.



