% MATLAB script for Assessment Item-1
% Task-2
clear; close all; clc;

%Load input image & convert to grayscale
X = imread('Images/Noisy.png');
grayX = rgb2gray(X); 

%pad array for 5x5 filter - needs 2 2 padding
pgrayX = padarray(grayX,[2 2]);

%create average and median filter images
meanImg = pgrayX;
medianImg = pgrayX;

for row = 3:size(pgrayX,1)-2
    for col = 3:size(pgrayX,2)-2
        maskArea = pgrayX(row-2:row+2,col-2:col+2);
        
        %find mean pixel
            %find sum of elements in 5x5 mask
            total = sum (maskArea, 'all');
            %calculate mean, and set to pixel for mean image
            meanImg(row,col) = total/25;
            
        %find median pixel
            %order elements in 5x5 mask
            ordered = sort(maskArea(:));
            %pick out median = 25+1 /2 = 13th value is center
            medianImg(row,col) = ordered(13);
            
    end
end

figure;
imshow(pgrayX);
xlabel('grayscale image');
figure;
imshow(meanImg);
xlabel('mean filtered');
figure;
imshow(medianImg);
xlabel('median filtered');

imwrite(meanImg, 'outputImages/Task2MeanImg.png');
imwrite(medianImg, 'outputImages/Task2medianImg.png');

