function [H, r, c] = harris_corner_detection(image, threshold, visual)

if nargin < 3
    visual = true;
end

G = gauss2D(1.5, [5,5]);
emp_const = 0.04;

I_g = imfilter(image, G, 'replicate');
[Ix, Iy, ~, ~] = compute_gradient(I_g);
%[Ix,Iy] = imgradientxy(I_g);

Ix_sq = Ix.^2;
Iy_sq = Iy.^2;
Ixy = Ix .* Iy;

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

% We interate from 2:rows/cols-1 for two reasons:
% 1. We dont want to bloat our code by distinguishing these edge cases.
% 2. Given that provided example images do not have interesting points at
%    its corners and edges, considering them will not lead to a better 
%    performance. We are aware that for other images the consideration of
%    these corner/edge pixels may be important.

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

r = corners(:, 1);
c = corners(:, 2);

if visual

    figure(1);
    subplot(1,3,1)
    imshow(mat2gray(Ix));
    mt(1) = title('\it{\bf{I}_x}', 'fontsize', 25);
    subplot(1,3,2)
    imshow(mat2gray(Iy));
    mt(2) = title('\it{\bf{I}_y}', 'fontsize', 25);
    subplot(1,3,3)
    imshow(image);
    hold on;
    plot(c, r, 'r*', 'LineWidth', 3, 'MarkerSize', 3);
    mt(3) = title('Original with corners', 'fontsize', 25);
end

end




    