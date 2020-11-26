%% SLAMデモ:3次元マップと走行データの抽出
% TurtleBotを使ってオドメトリデータと3次元点群データを取得
% ロボットの前方向をX軸、左方向をY軸、上方向をZ軸として定義
% オドメトリデータと3次元点群データから3次元マップと走行データ抽出

%% 初期化
clear; close all; clc;

%% ポイントクラウドデータのロード
% load('pointCloudData.mat'); % Kinectを使って取得したRGB-Dデータとロボットのオドメトリデータが必要

%% 必要なシステムオブジェクトの作成

% カメラ表示のためにビデオプレイヤーを作成
depVideoPlayer = vision.DeployableVideoPlayer;

% カメラをプロットするための回転行列を定義
Rz = [-1 0 0; ...
    0 -1 0;...
    0 0 1];
Ry = [0 0 1;
    0 1 0;
    -1 0 0];

%% 1番目のデータを取得
pcScene = pointCloudData{1, 1};

% Kinectのデータは遠くの部分の精度が低い
% 奥行き5m以内の範囲のデータだけを使う
indices = find(pcScene.Location(:,:,1) < 5);
pcScene = select(pcScene, indices(:));

figure
hAxes = pcshow(pcScene);
hAxes.CameraViewAngleMode = 'auto'; % 高速表示のための設定
hScatter = hAxes.Children;
hold on
% カメラの初期位置表示
cam = plotCamera('Location', [0,0,0], ...
    'Orientation', Rz'*Ry', ...
    'Opacity', 0.5, ...
    'Size', 0.1);

accumTform = affine3d();
visXYZ = zeros(size(pointCloudData,1),3);
gridSize = 0.015; % メートルで定義

%% 2番目以降のデータを取得
for n = 2:size(pointCloudData, 1)
    % ポイントクラウドデータの取り出し
    pc = pointCloudData{n, 1};
    
    % 奥行き5m以内のデータのみを取り出す
    indices = find(pc.Location(:,:,1) < 5);
    pc = select(pc, indices(:));
    
    % 取得された3次元点群を表示
    hScatterOrg.XData = pc.Location(:,1);
    hScatterOrg.YData = pc.Location(:,2);
    hScatterOrg.ZData = pc.Location(:,3);
    hScatterOrg.CData = pc.Color;
    
    % tformにオドメトリデータを取り出す(ワールド座標系にたいする座標変換行列)
    tform = pointCloudData{n, 2};
    
    % リファレンスフレームに対する変換行列を推定
    accumTform = affine3d(tform.T * accumTform.T);
    
    % 3次元点群の幾何学変換
    pc = pctransform(pc, tform);
    
    % 3次元点群同士のマージ
    pcScene = pcmerge(pc, pcScene, 0.02);
    
    % 取得された3次元点群を表示
    hScatter.XData = pcScene.Location(:,1);
    hScatter.YData = pcScene.Location(:,2);
    hScatter.ZData = pcScene.Location(:,3);
    hScatter.CData = pcScene.Color;
    
    % カメラの位置と向きを表示
    cam.Location = tform.T(4, 1:3);
    cam.Orientation = Rz'*Ry'*tform.T(1:3,1:3);
    
    % figureの表示更新
    drawnow('limitrate')
end

%% 終了

%  Copyright 2015 The MathWorks, Inc.

