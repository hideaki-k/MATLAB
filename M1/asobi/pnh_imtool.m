I = imread('sh_20081102T071400_wm8_fp_l_524.png');
C = imread('imgsh_20081102T071400_wm8_fp_l_524.png');
B = imfuse(I,C,'blend','Scaling','joint');
imshow(B);