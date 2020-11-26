%% Image Category Classification Using Deep Learning
% This example shows how to use a pre-trained Convolutional Neural Network
% (CNN) as a feature extractor for training an image category classifier. 
%
% Copyright 2018 The MathWorks, Inc.

%% Initialization

clear, close all

%% Load Pre-trained CNN

convnet = alexnet;
imageSize = convnet.Layers(1).InputSize;

%% Load Images

imds = imageDatastore(fullfile('./ImageData/17Flowers', {'Dandelion', 'ColtsFoot'}), ...
    'LabelSource', 'foldernames');
imds.ReadFcn = @(filename)readAndPreprocessImage(filename, imageSize);

%% 

figure, montageImageDatastore(imds, 'Dandelion')
figure, montageImageDatastore(imds, 'ColtsFoot')

%% Prepare Training and Test Image Sets

[trainingSet, testSet] = splitEachLabel(imds, 0.7, 'randomize');

%% Extract Features using CNN

featureLayer = 'fc7';
trainingFeatures = activations(convnet, trainingSet, featureLayer, 'MiniBatchSize', 1, 'OutputAs','rows');

%% Train A Multiclass SVM Classifier Using CNN Features

classifier = fitcsvm(trainingFeatures, trainingSet.Labels);

%% Evaluate Classifier

testFeatures = activations(convnet, testSet, featureLayer, 'MiniBatchSize',1, 'OutputAs', 'rows');
predictedLabels = predict(classifier, testFeatures);
C = confusionmat(testSet.Labels, predictedLabels);
