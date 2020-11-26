%% ?????????
I = imread('washer.jpg');
%imageSegmenter(I)
figure, imshow(I)

%% find circles( c:center, r:radius)
% Find circles
[c,r] = imfindcircles(I,[20 30],'ObjectPolarity','bright','Sensitivity',0.98);
ind_l = r > 25
I3 = insertShape(I, 'Circle', [c(ind_l,:), r(ind_l)], 'Color','blue', 'LineWidth',3);
I4 = insertShape(I3, 'Circle', [c(~ind_l,:), r(~ind_l)], 'Color','green', 'LineWidth',3);
I5 = insertText(I4, [10, 1], ['Count: Large=' num2str(nnz(ind_l)) ', Small=' num2str(nnz(~ind_l))], 'TextColor','white', 'FontSize',15);
imshow(I5); shg;
%% ??
% imfindcircles?????
% nnz????????????????
% Copyright 2014 The MathWorks, Inc.
