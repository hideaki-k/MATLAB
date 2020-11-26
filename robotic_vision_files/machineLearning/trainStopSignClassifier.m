%% 機械学習による標識認識
% HOG (Histogram of Oriented Gradient) 特徴量 と
%  SVM (Support Vector Machine) classifier を使った（2クラス分類）

%% 初期化
clear;clc;close all;imtool close all

%% 学習用のデータを確認
imDir = 'trainingData';
winopen(imDir);

%% imageSetを使った大規模画像の容易な取り扱い
imgSets = imageSet(imDir, 'recursive') % 再帰的に読み出し
{imgSets.Description}

%% imageSetを使った画像の分割
[trainingSets, testSets] = partition(imgSets, 0.95); % 9:1に分割                % randomized オプションもあり

%% stopの学習用画像を1つ取り出し
posIdx = strcmp('stop',{trainingSets.Description});
figure;imshow(read(trainingSets(posIdx), 1));

%% 前処理
% 画像のリサイズ
exTrainImage  = read(trainingSets(posIdx), 4);
img = imresize(exTrainImage,[32 32]);
figure;
subplot(1,2,1); imshow(exTrainImage);
subplot(1,2,2); imshow(img);

%% HOG 特徴量パラメータ(CellSize)の最適化 (画像サイズ:16x16 pixels)
% HOG: Histogram of Oriented Gradients
% HOG特徴量の抽出 (方向のBinは9つ)　(Blockサイズは2x2セル、Blockオーバーラップは1ピクセル)
%    セル毎に、各Pixelのエッジ方向のヒストグラムを作成（9方向）
[hog_2x2, vis2x2] = extractHOGFeatures(img,'CellSize',[2 2]);  % セルサイズ：2x2pixel、セル数：8x8、block位置:7x7=49、特徴ベクトルの長さ：9方向x(2x2セル/ブロック)x49=1764次元
[hog_4x4, vis4x4] = extractHOGFeatures(img,'CellSize',[4 4]);  % セルサイズ：4x4pixel、セル数：4x4、block位置:3x3= 9、特徴ベクトルの長さ：9方向x(2x2セル/ブロック)x 9= 324次元
[hog_8x8, vis8x8] = extractHOGFeatures(img,'CellSize',[8 8]);  % セルサイズ：8x8pixel、セル数：2x2、block位置:1x1= 1、特徴ベクトルの長さ：9方向x(2x2セル/ブロック)   =  36次元

% 各セル毎に、抽出したヒストグラムの表示（ベクトルは、"輝度の勾配"の垂線）
figure; subplot(2,3,1:3); imshow(img);   % 元画像
subplot(2,3,4); plot(vis2x2); 
title({'CellSize = [2 2]'; ['Feature length = ' num2str(length(hog_2x2))]});
subplot(2,3,5); plot(vis4x4); 
title({'CellSize = [4 4]'; ['Feature length = ' num2str(length(hog_4x4))]});
subplot(2,3,6); plot(vis8x8); 
title({'CellSize = [8 8]'; ['Feature length = ' num2str(length(hog_8x8))]});

%% 4x4のセルサイズを使用
cellSize = [4 4];
hogFeatureSize = length(hog_4x4);

%% 学習用のすべての画像について特徴量抽出
% trainingFeatures を格納する配列をあらかじめ作成
trainingFeatures  = zeros(sum([trainingSets.Count]),hogFeatureSize,'single');
trainingLabels = zeros(sum([trainingSets.Count]),1,'single');
% HOG特徴量を抽出
k = 1;
for l = 1:numel(trainingSets)
  for i = 1:trainingSets(l).Count
    img = read(trainingSets(l), i);  %トレーニング画像の読込み
    img = imresize(img,[32 32]);
    trainingFeatures(k,:) = extractHOGFeatures(img,'CellSize',cellSize); %特徴量の抽出
    trainingLabels(k) = l;
    k = k+1;
  end
end
% 分類学習器アプリを使うためのテーブルを生成する
trainingData = [trainingFeatures trainingLabels];

%% 分類学習器アプリケーションを使って学習器を作成
% Statistics and Machine Learning Toolboxの分類学習器アプリケーションを使用
classificationLearner

%% 分類学習器アプリケーションからコード生成下関数を使う場合
trainedClassifier = trainClassifier(trainingData);

%% 作成した分類器で識別･表示
Ir = zeros([32,32,3,numel(testSets)*4], 'uint8');      % 結果を格納する配列
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

% 結果の表示
figure;montage(Ir);

%% 終了

% Copyright 2015 The MathWorks, Inc.


