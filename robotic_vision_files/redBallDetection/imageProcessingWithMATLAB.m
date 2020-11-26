%% �Ԃ��{�[�����o�̏�����
% �摜�����ŐԂ��{�[�������o����

%% ������
clear, close all; imtool close all; clc;

%% �摜�ǂݍ���
% �ϐ��錾���s�v�A���I�m��
% imread�֐�: .jpg, .bmp�ȂǗl�X�ȉ摜�t�H�[�}�b�g�ɑΉ�
I = imread('imageProcessingExample.png');

%% �摜�̕\��
% �R�}���h1�ŃC���^���N�e�B�u�ɕ\��
figure, imshow(I);

%% �F�̂������l�A�v���P�[�V�������g���Ă������l�T��
% GUI���g���ăC���^���N�e�B�u�ɒT�����邱�Ƃ��\
% �T�������������l���֐��Ƃ��ăG�N�X�|�[�g�ł���
colorThresholder(I);

%% �ԐF�̕����𒊏o
BW = createMask(I);
figure, imshowpair(I,BW,'montage'); % 2�̉摜����ׂĔ�r

%% ���o���ꂽ�̈�̓����𖄂߂�
BW2 = imfill(BW,'holes'); % �����t�H���W�[�����Ȃǂ̂��܂��܂ȉ摜�����֐�
figure, imshowpair(BW,BW2,'montage');

%% �C���[�W�̗̈��̓A�v���P�[�V����
imageRegionAnalyzer(BW2);

%% �̈���
% �R�}���h���C���ŏ����������������邱�Ƃ��\�B
% �֐��̎g�p���@�Ȃǂ̏ڍׂȃw���v�h�L�������g�̒񋟁B
% �ʐρA�d�S�A�ΐS���A���a�����̒l�𒊏o�B
stat = regionprops('table',BW2,'Area','Centroid','Eccentricity','EquivDiameter','BoundingBox')

%% ���o���ꂽ�̈��}��
% �̂��قǋ@�B�w�K�̊w�K�f�[�^�����W���邽�߂Ɏg�p
I3 = insertShape(I,'rectangle',stat.BoundingBox,'LineWidth',5);
figure, imshow(I3);

%% �ΐS�����g���ĉ~�𔻕�(0�ɋ߂��قǐ^�~)
% �s��ƃX�J���[�̔�r���Z
% �s��̑���ɂ�����̗v�f�̒��o�A�����Ȃǂ��e��
idx = stat.Eccentricity < 0.1

%% ���o�����~������
% �����̂��߂̂��܂��܂Ȋ֐���p�ӁB
I2 = insertObjectAnnotation(I,'circle',[stat(idx,:).Centroid stat(idx,:).EquivDiameter/2],'Ball','LineWidth',5,'FontSize',35);
figure, imshow(I2);

%% �Ō�Ƀ��|�[�g�𐶐����Č��ʂ����L���邱�Ƃ��\
% �p�u���b�V���^�u�̃p�u���b�V���{�^�����N���b�N

% Copyright 2015 The MathWorks, Inc.

