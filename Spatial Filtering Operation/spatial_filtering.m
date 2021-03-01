%Name: Saksham Madan    Reg.No: 18BEC0724    Ph: 9674938252    Slot: L49-L50
%Task 2: 
%AIM: Performance of spatial filtering operations.
%Xray image of a wrist is used.
%Source code:

clc; %clear command window
clear variables; %clear workspace
close all; %clear current folder

% Reading the x-ray image
original_im = imread('xray1.jpg'); %reading image from folder
im = rgb2gray(original_im); %RGB to gray
im = imresize(im,[500 500]); %resizing image
figure(1);
subplot(2,2,1), imshow(im); %subplot to plot img in window
disp result
title('Original X-Ray Image'); %title of the image

% Adding noise to the image, and displaying them
im_gaussian_noise = imnoise(im,'gaussian'); %adding gaussian noise to image
subplot(2,2,2), imshow(im_gaussian_noise);
title('X-Ray Image with Gaussian Noise');
im_salt_pepper = imnoise(im,'Salt & Pepper'); %adding salt and pepper noise
subplot(2,2,[3 4]), imshow(im_salt_pepper);
title('X-Ray Image with Salt & Pepper noise');

%Removing noise using spatial filters (Median, High, Low)
%spatial filtering operation performed on salt and pepper noise
c = medfilt2(im_salt_pepper,[3 3]); % applying median filter
h = ones(5,5)/25; % averaing filter acts like a low pass, mask of 5X5 
% on image to filter image
b = imfilter(im_salt_pepper,h); %applying filter
h1 = fspecial('unsharp'); % high pass filter
d = imfilter(im_salt_pepper,h1); %applying filter
%displaying the images
figure('Name','Spatial filtering operation performed on salt and pepper noise'), 
subplot(2,2,1);
imshow(im_salt_pepper), title('Salt and Pepper Input Image');
subplot(2,2,2),imshow(c), title('Median Filtered Image');
subplot(2,2,3),imshow(b), title('Low Pass Filtered Image');
subplot(2,2,4),imshow(d), title('High Pass Filtered');

% Performing enhancement using contrast stretching
val = double(c);
contra1 = val + 25; %contrast by 25
%displaying the images
figure('Name','Performing enhancement using contrast stretching[Salt & Pepper');
subplot(1,2,1), imshow(c),title('Original Image(Salt and Pepper Noise)');
subplot(1,2,2), imshow(uint8(contra1)),title('Contrast Stretching');

%spatial filter operation performed on gaussian noise
%Removing noise using spatial filters (median ,high,low) 
c1=medfilt2(im_gaussian_noise,[3 3]); %applying median filter
h2=ones(5,5)/25; %low pass filter, mask of 5x5 on image to filter it.
b1=imfilter(im_gaussian_noise,h2); %applying filter
h3=fspecial('unsharp'); % high pass filter
d1=imfilter(im_gaussian_noise,h3); % applying filter
%displaying the images
figure('Name','Spatial filter operation performed on Gaussian Noise')
subplot(2,2,1), imshow(im_gaussian_noise);
title('Gaussian Input Image');
subplot(2,2,2), imshow(c1);
title('Median Filter');
subplot(2,2,3), imshow(b1);
title('Low Pass Filter');
subplot(2,2,4), imshow(d1);
title('High Pass Filter');

% Performing enhancement using contrast stretching
val=double(c1);
contra1=val + 25; %contrast by 25
%displaying the images
figure('Name','Performing enhancement using contrast stretching[Gaussian Noise]')
subplot(1,2,1), imshow(c1), title('Original Image(Gaussian Noise)');
subplot(1,2,2), imshow(uint8(contra1)), title('Contrast Stretching');

% Conclusion:

% An x-ray image of a wrist is intentionally added noise of type salt and
% pepper and Gaussian. Then the so obtained image was passed through
% spatial filterf of median, high and low to remove noise. Then the image
% was enhanced using contrast streching. 

%Obseravation:
%After the spatial operation is done, it is noted that fo salt and pepper
%the median filter offers the best result whereas for gaussian it is the
%low pass filter.