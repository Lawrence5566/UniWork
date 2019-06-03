% MATLAB script for Assessment Item-1
% Task-3
clear; close all; clc;

%Load input image & convert to grayscale
X = imread('Images/Starfish.jpg');
I = rgb2gray(X); 
figure;
imshow(I);
xlabel('original');

med = medfilt2(I); %median filter to remove salt and pepper noise
figure;
imshow(med);
xlabel('median filtering');

%enhance contrast with histogram equalisation - map light values to darker
%ones
cont = histeq(med);
figure;
imshow(cont);
xlabel('histogram equilisation (enhance contrast)');

%binarize image & take complement
%adaptive - is adaptive thresholding, not a set value
%ForegroundPolarity - foreground is darker than background
BW = imbinarize(cont, 'adaptive', 'ForegroundPolarity','dark','Sensitivity', 0.05);
%take complement
BWcomp = imcomplement(BW);
figure;
imshow(BWcomp);
xlabel('binarize - adaptive thresholding & complement');

%mean filter twice to remove noise and isolate objects
h = fspecial('average', 6);
BWsmooth = filter2(h, BWcomp);
BWsmooth = filter2(h, BWsmooth);
BWsmooth = BWsmooth > 0.5; %re-threshold
figure; %6
imshow(BWsmooth);
xlabel('mean filter & re-threshold');

%Used 50 instead of otsu thresholding as image is already equal, (used equalised histogram earlier) (few middle values)

%plot boundaries to show on image
figure;
imshow(BWsmooth);
hold on;
boundaries = bwboundaries(BWsmooth);
numberOfBoundaries = size(boundaries, 1);

for k = 1 : numberOfBoundaries
	thisBoundary = boundaries{k};
	plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
end
hold off;
xlabel('get/show boundaries');

%// show boundary signature of objects //%
stats = regionprops(BWsmooth, 'Centroid');
boundary = bwboundaries(BWsmooth);

%all object indexes/number of objects
objIndexes = zeros(1, size(length(stats), 2));

for k = 1 : length(stats)
   c = stats(k).Centroid; %get centroid of object for indexing position
   bound = boundary(k);   %get boundary positions of k (bound is single cell with NxM double array for each point along boundary)
   x = bound{1,1}(:,1);   %set x, y to extract boundary positions
   y = bound{1,1}(:,2);
   distancesOnGraph = sqrt((y - c(1)).^2 + (x - c(2)).^2); %calculate relational distance on graph using pythag
   t = 1:1:length(distancesOnGraph);
   
   %use gausian filter to smooth boundary signals (eliminates 'double peaks')
   w = gausswin(15);
   distancesOnGraph = filter(w,1,distancesOnGraph);
   
   %get peaks from boundary signal
   [pks,locs] = findpeaks(distancesOnGraph);
   
   %get troughs
   [pksNeg,locsNeg] = findpeaks(-distancesOnGraph);
   
   if (~isempty(pks) && ~isempty(pksNeg)) %make sure there are some peaks
       %only display if boundary has 5 peaks and 5 troughs (5 acute, 5 obtuse angles = starfish)
       if max(1:numel(pks)) == 5 && max(1:numel(pksNeg)) == 5
           figure(k+10),                 %add 10 to set figure after other figures
           plot(t,distancesOnGraph);     %we only plot the peaks
           xlabel('extracted boundary signal of object with 5 PEAKS and 5 TROUGHS (only peaks are labled)');
           text(locs+.02,pks,num2str((1:numel(pks))'))
           
           %starfish, so set index in list to 1 (used later)
           objIndexes(1, k) = 1;
       end
   end
end

%label image so that we can index objects
labeledImage = bwlabel(BWsmooth, 8);

keeperIndexes = find(objIndexes); %get list of indexes to keep
starfishObjImage = ismember(labeledImage, keeperIndexes);

maskedImage = BWsmooth; % create a copy
maskedImage(~starfishObjImage) = 0;  % Set all non-keeper pixels to zero.

figure;
imshow(maskedImage);
xlabel('display only images with 5 peaks and 5 troughs = starfish');

imwrite(maskedImage, 'outputImages/Task3maskedImage.png');