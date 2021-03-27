

clc;%clear command window
clear variables;%clear workspace
close all;%close all figures
a = imread("brain3.jpg");%read the input image
figure, imshow(a);%show the input image
title('Input Image');%title of the image
%loop to check if the image is in grayscale, if not to convert it to gray
%scale from RGB
try
    Dimg = rgb2gray(a);%conversion from RGB to gray
catch
    Dimg = a;%no need to convert it, already gray scale
end
imdata = reshape(Dimg, [], 1);%reshapping the input image with 65536x1 
%dimension
imdata = double(imdata);%handling large data

%%%%%%%Clustering the image%%%%%%%%%%
[IDX, nn] = kmeans(imdata, 3);%kmeans inbuilt command to cluster the input
%image into 3 different clusters

imIDX = reshape(IDX, size(Dimg));%reshaping the resultant image into
%the dimensions of the input image

figure, imshow(imIDX, []);
title('Index Image');
figure,
subplot(2, 2 , 1), imshow(imIDX == 1, []);%showing the 1st cluster
subplot(2, 2 , 2), imshow(imIDX == 2, []);%showing the 2nd cluster
subplot(2, 2 , 3), imshow(imIDX == 3, []);%showing the 3rd cluster


%%%%% SEGMENTING THE IMAGE %%%%%%%%%%%%
bw = (imIDX == 2);%selecting the cluster in which tumor is present
se = ones(5);%creating a structuring element of all ones(5x5)
bw = imopen(bw,se);%The morpholgical open opertation is an erosion followed
% by a dilation, using the same structuring element for both operations.
% Basically used to remove noise and, also for sharpening and smoothing of
% the image.
bw = bwareaopen(bw, 1200);%removes all connected components(objects) that 
% have fewer than 1200 pixels from the binary image bw
figure, imshow(bw);
title('Segmented Image');


%%%%% Feature Extraction %%%%%%%%%%%%
signal1 = bw(:,:);%storing all rows and all columns of bw image to parameter
%siganl1 
%Feature Extraction using DWT
[cA1, cH1, cV1, cD1] = dwt2(signal1, 'db4');%Computes the single-level 2-D
%discrete wavelet transfor(DWT) of the input data signal1 using the db4
%wavelet. dwt2 returnd=s the approximate coefficients matrix cA and detail
%coefficients matrices cH, cV and cD(horizontal, vertical and diagonal,
%respectively)
[cA2, cH2, cV2, cD2] = dwt2(cA1, 'db4');%second level 2D DWT
[cA3, cH3, cV3, cD3] = dwt2(cA2, 'db4');%third level 2D DWT
DWT_feat = [cA3, cH3, cV3, cD3]; %storing all coefficients in one variable
G = pca(DWT_feat);%Returns the proncipal component coefficients
g = graycomatrix(G);%creates the gray-level co-occurrence matrix (GLCM) by 
%calculating how often a pixel with gray-level (gray scale intensity) value
%i occurs horizontaly adjacent to a pixel with value j.
stats = graycoprops(g,'Contrast Correlation Energy Homogeneity');
%calculates the statistics specified in properties from the gray-level
%co-occurrence matrix glcm
Contrast = stats.Contrast%returns cached value of contrast
Correlation = stats.Correlation
Energy = stats.Energy
Homogeneity = stats.Homogeneity
Mean = mean2(G)
Standard_Deviation = std2(G)
Entropy = entropy(G)
RMS = mean2(rms(G))
Variance = mean2(var(double(G)))
b = sum(double(G(:)));
Smoothness = (1-(1/(1+b)))
Kurtosis = kurtosis(double(G(:)))
Skewness = skewness(double(G(:)))
m = size(G,1);
n = size(G,2);
in_diff = 0;
for i = 1:m
    for j = 1:n
        temp = G(i,j)./(1+(i-j).^2);
        in_diff = in_diff + temp;
    end
end

IDM = double(in_diff)

feat =[Contrast, Correlation, Energy, Homogeneity, Mean, Standard_Deviation, Entropy, RMS, Variance, Smoothness, Kurtosis, Skewness, IDM];
