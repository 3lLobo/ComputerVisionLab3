function [H, c, r] = harris_corner_detection(image, threshold)

G = gauss2D(1, [3,3]);
emp_const = 0.04;

I_gauss = imfilter(image, G, 'replicate');
[Ix,Iy] = imgradientxy(I_gauss);

Ix_sq = double(Ix).^2;
Iy_sq = double(Iy).^2;
Ixy = double(Ix) .* double(Iy);

A = imfilter(Ix_sq, G, 'replicate');
C = imfilter(Iy_sq, G, 'replicate');
B = imfilter(Ixy, G, 'replicate');

%fr = [A B];
%sr = [B C];
%Q = [fr; sr];
% H = det(Q)-emp_const*(trace(Q)).^2;

H = (A.*C - B.^2)-emp_const*(A+C).^2;
[rows, cols] = size(H);

corners = zeros(1, 2); 
corner_count = 1;

for i = 2:rows-1 
    for j = 2:cols-1
        if H(i, j) > threshold
            neighborh = H(i-1:i+1, j-1:j+1);
            if eq(neighborh(2, 2), max(neighborh, [], 'all'))
                corners(corner_count, :) = [i, j];
                corner_count = corner_count + 1;
            end
        end
    end
end

size(corners)

r = corners(:, 1);
c = corners(:, 2);

end


    