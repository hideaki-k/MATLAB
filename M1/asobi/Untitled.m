RGB = imread('strawberry.jpg');
figure, imshow(RGB)

%%
clear; close all; clc % ????
%% ???????
RGB = imread('strawberry.JPG');
figure, imshow(RGB)
%% ???????????(????????????????????????)
% Convert RGB image to chosen color space
I = rgb2hsv(RGB);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.922;
channel1Max = 0.040;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.459;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.403;
channel3Max = 1.000;

% Create mask based on chosen histogram thresholds
sliderBW = ( (I(:,:,1) >= channel1Min) | (I(:,:,1) <= channel1Max) ) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;

% Initialize output masked image based on input image.
maskedRGBImage = RGB;

% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
%% ???????(???????????????????????????)
BW_out = BW;
% Fill holes in regions.
BW_out = imfill(BW_out, 'holes');
% Filter image based on image properties.
BW_out = bwpropfilt(BW_out, 'Area', [60000, 60097]);

%% ??????????
[~,num] = bwlabel(BW_out)
RGB(~cat(3,BW_out,BW_out,BW_out))=0;
RGB = insertText(RGB,[20, 1],['Count:' num2str(num)],'TextColor','white', 'FontSize',24);
figure, imshow(RGB)
%% ??
% Copyright 2016 The MathWorks, Inc.

%%
