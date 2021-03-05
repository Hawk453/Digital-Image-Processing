% ECE3005 Digital Image Processing
% Task1- Feature Extraction using State of the Haar technique:
% Speeded-Up Robust Features (SURF)



clc; %clear command window
clear all; %clear workspace
close all; %close all current figures

I=imread('lena.bmp'); %reading the image
figure(1),imshow(I); %figure number %displaying the image
title('original image'); %title of image
I=imresize(I,[256,256]); %resizing of input image to dimension of 256x256
figure(2),imshow(I);title('resized image');
I=rgb2gray(I); %Converting image from RGB to GRAY
figure(3),imshow(I);title('gray image');
points1=detectSURFFeatures(I); %returns a SURFPoints object,%points, containing information about SURF features detected in the 2-%D grayscale input image I.
figure(5),imshow(I);
title('SURF features');
hold on;
plot(points1.selectStrongest(50)); %plotting 50 strongest features
Opoints=points1.Location(:,:); %retrieving the location of those strongest points
figure(6),imshow(I);
title('location of strongest points');
hold on;
plot(Opoints(:,1),Opoints(:,2),'r+');
axis off;

I2=imrotate(I,5,'bilinear','crop'); %rotating the input image attack
points2=detectSURFFeatures(I2);
Rpoints=points2.Location(:,:);
figure(7),imshow(I2);title('features after Rotating the image');
hold on;
plot(Rpoints(:,1),Rpoints(:,2),'r+');
axis off;

I3=imnoise(I,'salt & pepper',0.01); %adding salt and pepper noise in the input image attack
points3=detectSURFFeatures(I3);
Sppoints=points3.Location(:,:);
figure(8),imshow(I3);
title('features after adding salt and pepper noise in the image');
hold on;
plot(Sppoints(:,1),Sppoints(:,2),'r+');
axis off;

I4=imnoise(I,'speckle',0.01); %adding speckle noise in the input image #attack
points4=detectSURFFeatures(I4);
Splpoints=points4.Location(:,:);
figure(9),imshow(I4);
title('features after adding speckle noise in the image');
hold on;
plot(Splpoints(:,1),Splpoints(:,2),'r+');
axis off;

I5=imnoise(I,'gaussian',0.005); %adding gaussian noise in the input image #attack
points5=detectSURFFeatures(I5);
Gpoints=points5.Location(:,:);
figure(10),imshow(I5);
title('features after adding gaussian noise in the image');
hold on;
plot(Gpoints(:,1),Gpoints(:,2),'r+');
axis off;

I6=imtranslate(I,[5,5]); %traslate the input image #attack
points6=detectSURFFeatures(I6);
Tpoints=points6.Location(:,:);
figure(11),imshow(I6);
title('features after traslating the image');
hold on;
plot(Tpoints(:,1),Tpoints(:,2),'r+');
axis off;

imwrite(I,'0015.pgm','jpeg','quality',10); %introducing JPEG compression in the input image attack
I7=imread('0015.pgm');
points7=detectSURFFeatures(I7);
Jpoints=points7.Location(:,:);
figure(12),imshow(I7);
title('features after applying JPEG compression in the image');
hold on;
plot(Jpoints(:,1),Jpoints(:,2),'r+');
axis off;


% Results and Analysis: Using hausdorff distance we can analyze which
% attack gives more variation in features between the input image and
% 
% The output image:
%  Rotation(5)=0.122
%  Salt and pepper(0.01)=0.1549
%  Speckel(0.01)=0.1732
%  Gaussian(0.005)=0.2329
%  Traslate(5x5)=0.1977
%  jpeg(10)=0.1654
% 
% Conclusion
% Thus we understood and analyzed the feature extraction technique
% using SURF. Alongside a noise analysis between original and attacted image are
% measured for different types of noise and its parameters