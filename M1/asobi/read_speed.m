%% 読み込み
RGB = imread('speed_meter.png');
imshow(RGB);
%% 2値化
I = rgb2hsv(RGB);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.929;
channel1Max = 0.116;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.236;
channel2Max = 1.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.462;
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

%% 二値化結果の表示
imshow(BW);
stat = regionprops('table',BW,'Centroid',...
    'Area')

%% モルフォロジー処理
% ごみの処理
BW1 = imopen(BW,ones(4));imshow(BW1);