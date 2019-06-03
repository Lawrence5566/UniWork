% MATLAB script for Assessment Item-1
% Task-1

clear; close all; clc;

% Step-1: Load input image
X = imread('Images/Zebra.jpg');

% Step-2: Conversion of input image to grey-scale image
grayX = rgb2gray(X); 

%specify new & old image dimensions
ratio = 3;

oldH = size(grayX,1)-1; %-1 so that bi-lin loop never goes out of range
oldW = size(grayX,2)-1;
newH = size(grayX,1) * ratio;
newW = size(grayX,2) * ratio;

HScale = (oldH/newH);
WScale = (oldW/newW);

%generate new images
BilinImg = uint8(zeros(newH,newW));
nnImg = uint8(zeros(newH,newW));

%Step-3: Enlarge with nearest neighbour
for row = 1:newH
    for col = 1:newW
        Rindex = round(row/ratio);
        Cindex = round(col/ratio);
        
        %//check if index can go out of range
        if (Rindex == 0)
            Rindex = 1;
        elseif (Rindex >= oldH)
            Rindex = oldH;
        end
        
        if (Cindex == 0)
            Cindex = 1;
        elseif (Cindex >= oldW)
            Cindex = oldW;
        end
        
        %set pixel
        nnImg(row, col) = grayX(Rindex,Cindex); 
    end
end

%Step-4: Enlarge with Bilinear Interpolation
for i = 1:newH
    
    %relative position in old image
    %in output space maps to 0.5 in input space and '0.5+scale' in output
    %(same as imrezise)
    y = (HScale * i) + (0.5 * (1 - 1/ratio));
    
    for j = 1:newW
       %relative x position in old image
       x = (WScale * j) + (0.5 * (1 - 1/ratio));

       %Any values out of range - use array functions instead of if's this time
       x(x < 1) = 1;
       x(x > oldH - 0.001) = oldH - 0.001;
       x1 = floor(x); %(floor and ceiling of x)
       x2 = x1 + 1;
       
       y(y < 1) = 1;
       y(y > oldW - 0.001) = oldW - 0.001;
       y1 = floor(y);
       y2 = y1 + 1;
       y2(y2 > oldW - 0.001) = oldW - 0.001;
       
       %using formula: https://en.wikipedia.org/wiki/Bilinear_interpolation
       
       %4 pixel neighbour values
       Q11 = grayX(y1,x1);
       Q12 = grayX(y2,x1); 
       Q21 = grayX(y1,x2);
       Q22 = grayX(y2,x2);
          
       %in formula, linear interpolate in X&Y:

       BilinImg (i,j) = (y2-y)*(x2-x) * Q11 +...
                        (y2-y)*(x-x1) * Q21 +...
                        (x2-x)*(y-y1) * Q12 +...
                        (y-y1)*(x-x1) * Q22;
    end
end

figure;
imshow(X);
axis on;
title('Step-1: Load input image');

figure;
imshow(grayX);
axis on;
title('Step-2: Convert to grayscale');

figure;
imshow(nnImg);
axis on;
title('Step-3: Enlarge with nearest neighbour');

figure;
imshow(BilinImg);
axis on;
title('Step-4: Enlarge with Bilinear Interpolation');

imwrite(nnImg, 'outputImages/Task1NN.png');
imwrite(BilinImg, 'outputImages/Task1Bil.png');
