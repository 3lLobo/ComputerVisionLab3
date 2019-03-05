

I = imread('person_toy/00000001.jpg');
%I = imread('pingpong/0000.jpeg');
I = rgb2gray(I);
I = im2double(I);

[H, r, c] = harris_corner_detection(I, 0.005);





