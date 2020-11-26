%% �@�B�w�K�ɂ��W���F��
% HOG (Histogram of Oriented Gradient) ������ ��
%  SVM (Support Vector Machine) classifier ���g�����i2�N���X���ށj

%% ������
clear;clc;close all;imtool close all

%% �w�K�p�̃f�[�^���m�F
imDir = 'trainingData';
winopen(imDir);

%% imageSet���g������K�͉摜�̗e�ՂȎ�舵��
imgSets = imageSet(imDir, 'recursive') % �ċA�I�ɓǂݏo��
{imgSets.Description}

%% imageSet���g�����摜�̕���
[trainingSets, testSets] = partition(imgSets, 0.95); % 9:1�ɕ���                % randomized �I�v�V����������

%% stop�̊w�K�p�摜��1���o��
posIdx = strcmp('stop',{trainingSets.Description});
figure;imshow(read(trainingSets(posIdx), 1));

%% �O����
% �摜�̃��T�C�Y
exTrainImage  = read(trainingSets(posIdx), 4);
img = imresize(exTrainImage,[32 32]);
figure;
subplot(1,2,1); imshow(exTrainImage);
subplot(1,2,2); imshow(img);

%% HOG �����ʃp�����[�^(CellSize)�̍œK�� (�摜�T�C�Y:16x16 pixels)
% HOG: Histogram of Oriented Gradients
% HOG�����ʂ̒��o (������Bin��9��)�@(Block�T�C�Y��2x2�Z���ABlock�I�[�o�[���b�v��1�s�N�Z��)
%    �Z�����ɁA�ePixel�̃G�b�W�����̃q�X�g�O�������쐬�i9�����j
[hog_2x2, vis2x2] = extractHOGFeatures(img,'CellSize',[2 2]);  % �Z���T�C�Y�F2x2pixel�A�Z�����F8x8�Ablock�ʒu:7x7=49�A�����x�N�g���̒����F9����x(2x2�Z��/�u���b�N)x49=1764����
[hog_4x4, vis4x4] = extractHOGFeatures(img,'CellSize',[4 4]);  % �Z���T�C�Y�F4x4pixel�A�Z�����F4x4�Ablock�ʒu:3x3= 9�A�����x�N�g���̒����F9����x(2x2�Z��/�u���b�N)x 9= 324����
[hog_8x8, vis8x8] = extractHOGFeatures(img,'CellSize',[8 8]);  % �Z���T�C�Y�F8x8pixel�A�Z�����F2x2�Ablock�ʒu:1x1= 1�A�����x�N�g���̒����F9����x(2x2�Z��/�u���b�N)   =  36����

% �e�Z�����ɁA���o�����q�X�g�O�����̕\���i�x�N�g���́A"�P�x�̌��z"�̐����j
figure; subplot(2,3,1:3); imshow(img);   % ���摜
subplot(2,3,4); plot(vis2x2); 
title({'CellSize = [2 2]'; ['Feature length = ' num2str(length(hog_2x2))]});
subplot(2,3,5); plot(vis4x4); 
title({'CellSize = [4 4]'; ['Feature length = ' num2str(length(hog_4x4))]});
subplot(2,3,6); plot(vis8x8); 
title({'CellSize = [8 8]'; ['Feature length = ' num2str(length(hog_8x8))]});

%% 4x4�̃Z���T�C�Y���g�p
cellSize = [4 4];
hogFeatureSize = length(hog_4x4);

%% �w�K�p�̂��ׂẲ摜�ɂ��ē����ʒ��o
% trainingFeatures ���i�[����z������炩���ߍ쐬
trainingFeatures  = zeros(sum([trainingSets.Count]),hogFeatureSize,'single');
trainingLabels = zeros(sum([trainingSets.Count]),1,'single');
% HOG�����ʂ𒊏o
k = 1;
for l = 1:numel(trainingSets)
  for i = 1:trainingSets(l).Count
    img = read(trainingSets(l), i);  %�g���[�j���O�摜�̓Ǎ���
    img = imresize(img,[32 32]);
    trainingFeatures(k,:) = extractHOGFeatures(img,'CellSize',cellSize); %�����ʂ̒��o
    trainingLabels(k) = l;
    k = k+1;
  end
end
% ���ފw�K��A�v�����g�����߂̃e�[�u���𐶐�����
trainingData = [trainingFeatures trainingLabels];

%% ���ފw�K��A�v���P�[�V�������g���Ċw�K����쐬
% Statistics and Machine Learning Toolbox�̕��ފw�K��A�v���P�[�V�������g�p
classificationLearner

%% ���ފw�K��A�v���P�[�V��������R�[�h�������֐����g���ꍇ
trainedClassifier = trainClassifier(trainingData);

%% �쐬�������ފ�Ŏ��ʥ�\��
Ir = zeros([32,32,3,numel(testSets)*4], 'uint8');      % ���ʂ��i�[����z��
cmap = lines(numel(testSets))*255;
trainedLabels={imgSets.Description};
for l = 1:numel(testSets) 
  for i = 1:4
    img = read(testSets(l), randi([1 testSets(l).Count]));     
    img = imresize(img,[32 32]);
    testFeatures = extractHOGFeatures(img,'CellSize',cellSize);
    predictedIndex = trainedClassifier.predictFcn(testFeatures);
    predictedLabel = trainedLabels{predictedIndex};
    img = insertText(img,[8,8],predictedLabel,'BoxColor',cmap(predictedIndex,:));
    Ir(:,:,:,(l-1)*4+i)=img;
  end
end

% ���ʂ̕\��
figure;montage(Ir);

%% �I��

% Copyright 2015 The MathWorks, Inc.


