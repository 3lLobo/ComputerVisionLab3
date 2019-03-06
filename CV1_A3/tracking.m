mainfolder = strcat(pwd, '\');
subfolder = 'pingpong\';

% Load all files
matfiles = dir(fullfile(mainfolder, subfolder, '*.jpeg'));
nfiles = length(matfiles);

% Set values
harris_treshold = 0.005;
window_size = 20;

% Reading out first file
I_pp = imread(fullfile(mainfolder, subfolder, matfiles(1).name));
I_pp_gray = rgb2gray(I_pp);
I_pp_gd = im2double(I_pp_gray);

% Calculate the positions in the first frame so:
% Perform harris to get the corners c
[H, r, c] = harris_corner_detection(I_pp_gd, harris_treshold, false);

% So c are the features we want to track


for filenr = 1 : nfiles - 1
    % Getting the movement directions using lucas kanade:
    [V_x, V_y] = lucas_kanade(fullfile(mainfolder, subfolder, matfiles(filenr).name), fullfile(mainfolder, subfolder, matfiles(filenr+1).name), window_size);

    [m,n] = size(V_x);
    dx = zeros(length(r), 1);
    dy = zeros(length(r), 1);

    
    for  i = 1: length(r)
        posc = round(c(i)/window_size) + 1;
        posr = round(r(i)/window_size) + 1;

        if posr > m
            posr = m;
        elseif posr < 0
            posr = 0;
        end
        if posc > n
            posc = n;
        elseif posc < 0
            posc = 0;
        end
        dx(i, 1) = V_x(posr, posc);
        dy(i, 1) = V_y(posr, posc);
    end

    % Save temporary results to file
    f = figure('visible','off');
    imshow(fullfile(mainfolder, subfolder, matfiles(filenr).name));
    hold on;
    plot(c, r, 'r*', 'LineWidth', 2, 'MarkerSize', 2);
    %plot(c + dx, r + dy, 'g*', 'LineWidth', 2, 'MarkerSize', 2);
    quiver(c,r,dx,dy, 'color',[1 0 1]);

    name = (['Feature tracking with window size ', num2str(window_size)]);
    title(name, 'fontsize', 15);
    saveas(f, strcat(mainfolder,'results_pingpong\', erase(matfiles(filenr).name,'.jpg')));
    c = c + (dx*window_size);
    r = r + (dy*window_size);
end