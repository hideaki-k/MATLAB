I = imread('sample.jpg');
%imshow(I)
I = rgb2gray(I)

GInfo=imfinfo('sample.jpg');
h=GInfo.Height
w=GInfo.Width
%?????
u=mean(I,'all')
disp(I)
for k=1:h;
 for c =1:w
    index=[k,c];
    if rem(c,2) == 0
        I(k,c)=0;
    end
 end   
end
disp(I)
imshow(I)