imageSize = [480 640 3];
numClasses = 5;
network = 'resnet18';
lgraph = deeplabv3plusLayers(imageSize,numClasses,network, ...
             'DownsamplingFactor',16);
disp('finish')    