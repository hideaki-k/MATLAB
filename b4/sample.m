layers = [ ...
imageInputLayer([28 28 1], 'Normalization', 'none');
convolution2dLayer(5, 20);
reluLayer();
maxPooling2dLayer(2, 'Stride', 2);
fullyConnectedLayer(10);
softmaxLayer();
classificationLayer()];


[XTrain,TTrain] = digitTrain4DArrayData;
montage(XTrain(:,:,:,1:36))

opts = trainingOptions('sgdm', 'MaxEpochs', 50);
net = trainNetwork(XTrain, TTrain, layers, opts);

[XTest,TTest]=digitTest4DArrayData;
YTest = classify(net,XTest);

accuracy=sum(YTest==TTest)/numel(TTest);
disp(['ï™óﬁê∏ìxÅF' num2str(accuracy)])

C=confusionmat(YTest,TTest)
