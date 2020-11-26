%% 赤いボール検出の処理例
% 画像処理で赤いボールを検出する

%% 初期化
clear, close all; imtool close all; clc;

%% 画像読み込み
% 変数宣言が不要、動的確保
% imread関数: .jpg, .bmpなど様々な画像フォーマットに対応
I = imread('imageProcessingExample.png');

%% 画像の表示
% コマンド1つでインタラクティブに表示
figure, imshow(I);

%% 色のしきい値アプリケーションを使ってしきい値探索
% GUIを使ってインタラクティブに探索することも可能
% 探索したしきい値を関数としてエクスポートできる
colorThresholder(I);

%% 赤色の部分を抽出
BW = createMask(I);
figure, imshowpair(I,BW,'montage'); % 2つの画像を並べて比較

%% 抽出された領域の内部を埋める
BW2 = imfill(BW,'holes'); % モルフォロジー処理などのさまざまな画像処理関数
figure, imshowpair(BW,BW2,'montage');

%% イメージの領域解析アプリケーション
imageRegionAnalyzer(BW2);

%% 領域解析
% コマンドラインで処理を自動化させることも可能。
% 関数の使用方法などの詳細なヘルプドキュメントの提供。
% 面積、重心、偏心率、直径相当の値を抽出。
stat = regionprops('table',BW2,'Area','Centroid','Eccentricity','EquivDiameter','BoundingBox')

%% 検出された領域を図示
% のちほど機械学習の学習データを収集するために使用
I3 = insertShape(I,'rectangle',stat.BoundingBox,'LineWidth',5);
figure, imshow(I3);

%% 偏心率を使って円を判別(0に近いほど真円)
% 行列とスカラーの比較演算
% 行列の操作による特定の要素の抽出、除去などが容易
idx = stat.Eccentricity < 0.1

%% 検出した円を可視化
% 可視化のためのさまざまな関数を用意。
I2 = insertObjectAnnotation(I,'circle',[stat(idx,:).Centroid stat(idx,:).EquivDiameter/2],'Ball','LineWidth',5,'FontSize',35);
figure, imshow(I2);

%% 最後にレポートを生成して結果を共有することが可能
% パブリッシュタブのパブリッシュボタンをクリック

% Copyright 2015 The MathWorks, Inc.

