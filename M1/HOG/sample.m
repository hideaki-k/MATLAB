img = imread('car.jpg');
disp(size(img));

imshow(img)
img_y,img_x=size(img)  

[featureVector,hogVisualization] = extractHOGFeatures(img,'CellSize',[8 8],'BlockSize',[4 4]);
%disp(featureVector);
figure;
imshow(img); 
hold on;
plot(hogVisualization);
%plot(hogVisualization,AX) 
%plot(featureVector);