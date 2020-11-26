I = imread('sample.jpg');
%imshow(I)
I = rgb2gray(I);
cnt = double(0)
disp(class(cnt))
GInfo=imfinfo('sample.jpg');
h=GInfo.Height;
w=GInfo.Width;
F=h*w;
%?????
u=mean(I,'all');
%????
%disp(I);
for k=1:h;
 for c =1:w
    index=[k,c];
    cnt=cnt+I(k,c);
 end   
end
disp(cnt)
