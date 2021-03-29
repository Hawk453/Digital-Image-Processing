% Task 4: Brain Tumor Detection and classification using ANN(nprtool)

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
Mean = mean2(G)%computes the mean of all values in array G
Standard_Deviation = std2(G)%computes the standard deviation of all values 
%in the array G
Entropy = entropy(G)%computes the entropy of all values in array G
RMS = mean2(rms(G))%computes the RMS value of all values in array G
Variance = mean2(var(double(G)))%computes the Variance of all values in array G
b = sum(double(G(:)));%adding all the values of matrix G
Smoothness = (1-(1/(1+b)))%Calculating smoothness of G
Kurtosis = kurtosis(double(G(:)))%Calculating Kurtosis of G
Skewness = skewness(double(G(:)))%Calculating Skewness of G
m = size(G,1);
n = size(G,2);
in_diff = 0;
for i = 1:m
    for j = 1:n
        temp = G(i,j)./(1+(i-j).^2);
        in_diff = in_diff + temp;
    end
end

IDM = double(in_diff)%Calculating IDM of G
%Displaying all the features in 1 variable
feat =[Contrast, Correlation, Energy, Homogeneity, Mean, Standard_Deviation, Entropy, RMS, Variance, Smoothness, Kurtosis, Skewness, IDM];


%%%%%  Conclusion %%%%%%%%%%%
% In this experiment we have taken 15 samples 10 are Malignant (HGG) and 
% 5 are Benign (LGG). Kmean clustering technique is applied to detect the 
% tumor, alongside 13 features were detected of each and every sample.
% The data base was establised for 15 samples, named as TRAIN ANN.mat and 
% target was created using database. Using nprtool the experiment was 
% performed and the accuracy was calculated through confusion matrix 
% ((TP+TN)/TP+FN+FP+TF). It is obsered for 15 samples we achieved 60% of 
% accuracy, by increasing the number of training set we aim to achieve
% more accuracy.


%%% Significance of DWT here:

%The 2-D wavelet decomposition algorithm for images is similar to the 
%one-dimensional case. The two-dimensional wavelet and scaling functions 
%are obtained by taking the tensor products of the one-dimensional wavelet 
%and scaling functions. This kind of two-dimensional DWT leads to a 
%decomposition of approximation coefficients at level j in four components:
%the approximation at level j + 1, and the details in three orientations 
%(horizontal, vertical, and diagonal). First, the one-dimensional DWT is 
%applied along the rows;second, the one-dimensional DWT is applied along 
%the columns of the first-stage result, generating foursub-band regions in 
%the transformed space: LL, LH, HL and HH.