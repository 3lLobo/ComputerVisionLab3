function [H, c, r] = harris_corner_detection(image)

I = imread(image);
I = rgb2gray(I);

[Ix,Iy] = imgradientxy(I);
A = Ix.^2;
B = Ix.^Iy;
C = Iy.^2;

% apply Gaussian
A = imgaussfilt(A,0.5);
B = imgaussfilt(B,0.5);
C = imgaussfilt(C,0.5);

Q = [A B,
    B C];

H = (A.*C - B.^2) - 0.04*(A + C).^2;
[r, c] = find(H);

end
