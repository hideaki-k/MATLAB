%% Visual-SLAM�̃f��
% Kinect���g���Ĉړ����Ă��郍�{�b�g����RGB-D�f�[�^�����W
% ���{�b�g�̍ŏ��̌�����X�������Ƃ��Ē�`

%% ������
clear; close all; clc;
rng('default');

%% 3�����_�Q�̃f�[�^�����[�h
% load('kitchenPointClouds.mat'); % Kinect���g���Ď擾����RGB-D�f�[�^���K�v

%% �����t���[�������t�@�����X�Ƃ��ēǂݍ��݁A�\��
pc1 = kitchenPointClouds{1};
accumTform = affine3d();
visXYZ = zeros(size(kitchenPointClouds,1),3);
visXYZ(1, :) = accumTform.T(4,1:3);
gridSize = 0.015; % ���[�g���Œ�`

% �����t���[���̕\���Ɛݒ�
% 3�����_�Q�\���ݒ�
hFig = figure;
hAxes = pcshow(pc1);
hAxes.CameraViewAngleMode = 'auto'; % �����\���̂��߂̐ݒ�
hAxes.XLim = [-0.5, 6];
hAxes.YLim = [-0.5, 5];
hAxes.ZLim = [-0.5, 3];
hScatter = hAxes.Children;
hold on
% �J�������v���b�g���邽�߂̉�]�s����`
Rz = [cos(-45/180*pi) -sin(-45/180*pi) 0;
    sin(-45/180*pi) cos(-45/180*pi) 0;
    0 0 1];
Rx = [1 0 0;
    0 0 1;
    0 -1  0];
% �J�����̏����ʒu�\��
cam = plotCamera('Location', [0,0,0], ...
    'Orientation', Rx'*Rz'*accumTform.T(1:3,1:3), ...
    'Opacity', 0.5, ...
    'Size', 0.1);
% �����_�}�b�`���O�̕\���ݒ�
figure;
hAxes = axes;

%% 2�t���[���ڎ擾
pc2 = kitchenPointClouds{2};

%% 2�����œ����_�}�b�`���O
% �O�̃t���[�����猻�݂̃t���[���ւ̕ϊ��s��𐄒�
% (Z�������̓����͂Ȃ��Ɖ��肷��)
tform = findRtFromRGBD(pc2, pc1, true, hAxes);
tform.T

%% �����t���[���ɑ΂���ϊ��s��𐄒�
accumTform = affine3d(tform.T * accumTform.T);
visXYZ(2, :) = accumTform.T(4,1:3); % ���݂̃t���[���ł̃��{�b�g�̈ʒu���L�^

%% �ϊ��s������݂̃t���[����3�����_�Q�ɓK�p
pc2mod = pctransform(pc2,accumTform);

%% 3�����_�Q���m�𓝍�����
pc = pcmerge(pc1, pc2mod, gridSize);

%% �擾���ꂽ3�����_�Q������
hScatter.XData = pc.Location(:,1);
hScatter.YData = pc.Location(:,2);
hScatter.ZData = pc.Location(:,3);
hScatter.CData = reshape(pc.Color,[],3);

%% �J�����̈ʒu�\��
cam.Location = accumTform.T(4, 1:3);

%% ���t���[���ȍ~��2�����œ����_�}�b�`���O������3�����̊􉽊w�ϊ��s��𐄒�
for k = 3:size(kitchenPointClouds,1)
    %fprintf('frame %d\n',k);
    
    % 1�O�̃|�C���g�N���E�h�ƌ��݂̃|�C���g�N���E�h
    pc1 = kitchenPointClouds{k-1};
    pc2 = kitchenPointClouds{k};
    
    % �O�̃t���[�����猻�݂̃t���[���ւ̕ϊ��s��𐄒�
    % (Z�������̓����͂Ȃ��Ɖ��肷��)
    tform = findRtFromRGBD(pc2, pc1, true, hAxes);
    
    % ���t�@�����X�t���[���ɑ΂���ϊ��s��𐄒�
    accumTform = affine3d(tform.T * accumTform.T);
    pc2 = pctransform(pc2,accumTform);
    
    % 3�����_�Q��D�����킹��
    pc = pcmerge(pc, pc2, gridSize);
    
    % ���݂̃t���[���ł̃��{�b�g�̈ʒu���L�^
    visXYZ(k, :) = accumTform.T(4,1:3);
    
    % 3�����_�Q��\��
    % �擾���ꂽ3�����_�Q��\��
    hScatter.XData = pc.Location(:,1);
    hScatter.YData = pc.Location(:,2);
    hScatter.ZData = pc.Location(:,3);
    hScatter.CData = reshape(pc.Color,[],3);
    
    % �J�����̈ʒu�ƌ�����\��
    cam.Location = accumTform.T(4, 1:3);
    
    % �t���[�����X�V
    drawnow limitrate
    
end

%% �L�^�����I�h���g���[�f�[�^��\��
figure
plot3(visXYZ(:,1), visXYZ(:,2), visXYZ(:,3), 'x-')
xlabel('X (meter)')
ylabel('Y (meter)')
zlabel('Z (meter)')
axis equal
grid on;

%% ����ꂽ�n�}�f�[�^(3�����_�Q)����n�ʂ𐄒�
ptCloud = pc;
maxDistance = 0.03; % ���ʓ��̓_�Ԃ̍ő勗����3cm�Ɏw��
referenceVector = [0,0,1]; % ���o���镽�ʂ̖@���x�N�g�����w��
maxAngularDistance = 5; % �@���x�N�g������5�x�ȓ��̕��ʂ�������
[planeMdl1, ~, outlierIndices] = pcfitplane(ptCloud, maxDistance,referenceVector,maxAngularDistance);
remainPtCloud = select(ptCloud, outlierIndices);
figure(hFig);
hold on;
h1 = plot(planeMdl1);
h1.FaceAlpha = 0.5;

%% ����ꂽ�n�}�f�[�^(3�����_�Q)����ǖʂ����o
referenceVector = [1,0,0]; % ���o���镽�ʂ̖@���x�N�g�����w��
maxAngularDistance = 5; % �@���x�N�g������5�x�ȓ��̕��ʂ�������
[planeMdl2, ~, outlierIndices] = pcfitplane(remainPtCloud,maxDistance,referenceVector,maxAngularDistance);
remainPtCloud = select(remainPtCloud, outlierIndices);
h2 = plot(planeMdl2);
h2.FaceColor = [1,1,0];
h2.FaceAlpha = 0.5;

%% ����ꂽ�n�}�f�[�^(3�����_�Q)����ǖʂ����o
referenceVector = [1,0,0]; % ���o���镽�ʂ̖@���x�N�g�����w��
maxAngularDistance = 10; % �@���x�N�g������5�x�ȓ��̕��ʂ�������
[planeMdl3, ~, outlierIndices] = pcfitplane(remainPtCloud,maxDistance,referenceVector,maxAngularDistance);
remainPtCloud = select(remainPtCloud, outlierIndices);
h3 = plot(planeMdl3);
h3.FaceColor = [1,0,1];
h3.FaceAlpha = 0.5;

%% �I��

%  Copyright 2015 The MathWorks, Inc.