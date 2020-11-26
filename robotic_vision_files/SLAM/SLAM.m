%% SLAM�f��:3�����}�b�v�Ƒ��s�f�[�^�̒��o
% TurtleBot���g���ăI�h���g���f�[�^��3�����_�Q�f�[�^���擾
% ���{�b�g�̑O������X���A��������Y���A�������Z���Ƃ��Ē�`
% �I�h���g���f�[�^��3�����_�Q�f�[�^����3�����}�b�v�Ƒ��s�f�[�^���o

%% ������
clear; close all; clc;

%% �|�C���g�N���E�h�f�[�^�̃��[�h
% load('pointCloudData.mat'); % Kinect���g���Ď擾����RGB-D�f�[�^�ƃ��{�b�g�̃I�h���g���f�[�^���K�v

%% �K�v�ȃV�X�e���I�u�W�F�N�g�̍쐬

% �J�����\���̂��߂Ƀr�f�I�v���C���[���쐬
depVideoPlayer = vision.DeployableVideoPlayer;

% �J�������v���b�g���邽�߂̉�]�s����`
Rz = [-1 0 0; ...
    0 -1 0;...
    0 0 1];
Ry = [0 0 1;
    0 1 0;
    -1 0 0];

%% 1�Ԗڂ̃f�[�^���擾
pcScene = pointCloudData{1, 1};

% Kinect�̃f�[�^�͉����̕����̐��x���Ⴂ
% ���s��5m�ȓ��͈̔͂̃f�[�^�������g��
indices = find(pcScene.Location(:,:,1) < 5);
pcScene = select(pcScene, indices(:));

figure
hAxes = pcshow(pcScene);
hAxes.CameraViewAngleMode = 'auto'; % �����\���̂��߂̐ݒ�
hScatter = hAxes.Children;
hold on
% �J�����̏����ʒu�\��
cam = plotCamera('Location', [0,0,0], ...
    'Orientation', Rz'*Ry', ...
    'Opacity', 0.5, ...
    'Size', 0.1);

accumTform = affine3d();
visXYZ = zeros(size(pointCloudData,1),3);
gridSize = 0.015; % ���[�g���Œ�`

%% 2�Ԗڈȍ~�̃f�[�^���擾
for n = 2:size(pointCloudData, 1)
    % �|�C���g�N���E�h�f�[�^�̎��o��
    pc = pointCloudData{n, 1};
    
    % ���s��5m�ȓ��̃f�[�^�݂̂����o��
    indices = find(pc.Location(:,:,1) < 5);
    pc = select(pc, indices(:));
    
    % �擾���ꂽ3�����_�Q��\��
    hScatterOrg.XData = pc.Location(:,1);
    hScatterOrg.YData = pc.Location(:,2);
    hScatterOrg.ZData = pc.Location(:,3);
    hScatterOrg.CData = pc.Color;
    
    % tform�ɃI�h���g���f�[�^�����o��(���[���h���W�n�ɂ���������W�ϊ��s��)
    tform = pointCloudData{n, 2};
    
    % ���t�@�����X�t���[���ɑ΂���ϊ��s��𐄒�
    accumTform = affine3d(tform.T * accumTform.T);
    
    % 3�����_�Q�̊􉽊w�ϊ�
    pc = pctransform(pc, tform);
    
    % 3�����_�Q���m�̃}�[�W
    pcScene = pcmerge(pc, pcScene, 0.02);
    
    % �擾���ꂽ3�����_�Q��\��
    hScatter.XData = pcScene.Location(:,1);
    hScatter.YData = pcScene.Location(:,2);
    hScatter.ZData = pcScene.Location(:,3);
    hScatter.CData = pcScene.Color;
    
    % �J�����̈ʒu�ƌ�����\��
    cam.Location = tform.T(4, 1:3);
    cam.Orientation = Rz'*Ry'*tform.T(1:3,1:3);
    
    % figure�̕\���X�V
    drawnow('limitrate')
end

%% �I��

%  Copyright 2015 The MathWorks, Inc.

