%% Visual-SLAMのデモ
% Kinectを使って移動しているロボットからRGB-Dデータを収集
% ロボットの最初の向きをX軸方向として定義

%% 初期化
clear; close all; clc;
rng('default');

%% 3次元点群のデータをロード
% load('kitchenPointClouds.mat'); % Kinectを使って取得したRGB-Dデータが必要

%% 初期フレームをリファレンスとして読み込み、表示
pc1 = kitchenPointClouds{1};
accumTform = affine3d();
visXYZ = zeros(size(kitchenPointClouds,1),3);
visXYZ(1, :) = accumTform.T(4,1:3);
gridSize = 0.015; % メートルで定義

% 初期フレームの表示と設定
% 3次元点群表示設定
hFig = figure;
hAxes = pcshow(pc1);
hAxes.CameraViewAngleMode = 'auto'; % 高速表示のための設定
hAxes.XLim = [-0.5, 6];
hAxes.YLim = [-0.5, 5];
hAxes.ZLim = [-0.5, 3];
hScatter = hAxes.Children;
hold on
% カメラをプロットするための回転行列を定義
Rz = [cos(-45/180*pi) -sin(-45/180*pi) 0;
    sin(-45/180*pi) cos(-45/180*pi) 0;
    0 0 1];
Rx = [1 0 0;
    0 0 1;
    0 -1  0];
% カメラの初期位置表示
cam = plotCamera('Location', [0,0,0], ...
    'Orientation', Rx'*Rz'*accumTform.T(1:3,1:3), ...
    'Opacity', 0.5, ...
    'Size', 0.1);
% 特徴点マッチングの表示設定
figure;
hAxes = axes;

%% 2フレーム目取得
pc2 = kitchenPointClouds{2};

%% 2次元で特徴点マッチング
% 前のフレームから現在のフレームへの変換行列を推定
% (Z軸方向の動きはないと仮定する)
tform = findRtFromRGBD(pc2, pc1, true, hAxes);
tform.T

%% 初期フレームに対する変換行列を推定
accumTform = affine3d(tform.T * accumTform.T);
visXYZ(2, :) = accumTform.T(4,1:3); % 現在のフレームでのロボットの位置を記録

%% 変換行列を現在のフレームの3次元点群に適用
pc2mod = pctransform(pc2,accumTform);

%% 3次元点群同士を統合する
pc = pcmerge(pc1, pc2mod, gridSize);

%% 取得された3次元点群を可視化
hScatter.XData = pc.Location(:,1);
hScatter.YData = pc.Location(:,2);
hScatter.ZData = pc.Location(:,3);
hScatter.CData = reshape(pc.Color,[],3);

%% カメラの位置表示
cam.Location = accumTform.T(4, 1:3);

%% 次フレーム以降を2次元で特徴点マッチングをして3次元の幾何学変換行列を推定
for k = 3:size(kitchenPointClouds,1)
    %fprintf('frame %d\n',k);
    
    % 1つ前のポイントクラウドと現在のポイントクラウド
    pc1 = kitchenPointClouds{k-1};
    pc2 = kitchenPointClouds{k};
    
    % 前のフレームから現在のフレームへの変換行列を推定
    % (Z軸方向の動きはないと仮定する)
    tform = findRtFromRGBD(pc2, pc1, true, hAxes);
    
    % リファレンスフレームに対する変換行列を推定
    accumTform = affine3d(tform.T * accumTform.T);
    pc2 = pctransform(pc2,accumTform);
    
    % 3次元点群を縫い合わせる
    pc = pcmerge(pc, pc2, gridSize);
    
    % 現在のフレームでのロボットの位置を記録
    visXYZ(k, :) = accumTform.T(4,1:3);
    
    % 3次元点群を表示
    % 取得された3次元点群を表示
    hScatter.XData = pc.Location(:,1);
    hScatter.YData = pc.Location(:,2);
    hScatter.ZData = pc.Location(:,3);
    hScatter.CData = reshape(pc.Color,[],3);
    
    % カメラの位置と向きを表示
    cam.Location = accumTform.T(4, 1:3);
    
    % フレームを更新
    drawnow limitrate
    
end

%% 記録したオドメトリーデータを表示
figure
plot3(visXYZ(:,1), visXYZ(:,2), visXYZ(:,3), 'x-')
xlabel('X (meter)')
ylabel('Y (meter)')
zlabel('Z (meter)')
axis equal
grid on;

%% 得られた地図データ(3次元点群)から地面を推定
ptCloud = pc;
maxDistance = 0.03; % 平面内の点間の最大距離を3cmに指定
referenceVector = [0,0,1]; % 検出する平面の法線ベクトルを指定
maxAngularDistance = 5; % 法線ベクトルから5度以内の平面を見つける
[planeMdl1, ~, outlierIndices] = pcfitplane(ptCloud, maxDistance,referenceVector,maxAngularDistance);
remainPtCloud = select(ptCloud, outlierIndices);
figure(hFig);
hold on;
h1 = plot(planeMdl1);
h1.FaceAlpha = 0.5;

%% 得られた地図データ(3次元点群)から壁面を検出
referenceVector = [1,0,0]; % 検出する平面の法線ベクトルを指定
maxAngularDistance = 5; % 法線ベクトルから5度以内の平面を見つける
[planeMdl2, ~, outlierIndices] = pcfitplane(remainPtCloud,maxDistance,referenceVector,maxAngularDistance);
remainPtCloud = select(remainPtCloud, outlierIndices);
h2 = plot(planeMdl2);
h2.FaceColor = [1,1,0];
h2.FaceAlpha = 0.5;

%% 得られた地図データ(3次元点群)から壁面を検出
referenceVector = [1,0,0]; % 検出する平面の法線ベクトルを指定
maxAngularDistance = 10; % 法線ベクトルから5度以内の平面を見つける
[planeMdl3, ~, outlierIndices] = pcfitplane(remainPtCloud,maxDistance,referenceVector,maxAngularDistance);
remainPtCloud = select(remainPtCloud, outlierIndices);
h3 = plot(planeMdl3);
h3.FaceColor = [1,0,1];
h3.FaceAlpha = 0.5;

%% 終了

%  Copyright 2015 The MathWorks, Inc.