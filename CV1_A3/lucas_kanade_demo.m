function lucas_kanade_demo(path1, path2, window_size)
    [V_x, V_y] = lucas_kanade(path1, path2, window_size);
    plot_only_quiver(V_x, V_y, window_size);
    plot_on_image(path1, V_x, V_y, window_size); 
end

function plot_only_quiver(V_x, V_y, win_size)
    i = ceil(win_size/2);
    num_win = size(V_x, 1);
    [x,y] = meshgrid(i:win_size:num_win*win_size,num_win*win_size:-win_size:i);
    quiver(x,y,V_x,-V_y, 'color',[1 0 1]);  
end

function plot_on_image(path, V_x, V_y, win_size)    
    i = ceil(win_size/2);
    num_win = size(V_x, 1);
    [x,y] = meshgrid(i:win_size:num_win*win_size,i:win_size:num_win*win_size);
    
    figure;
    imshow(imread(path), []);
    hold on;
    quiver(x,y,V_x,V_y, 'color',[1 0 1]);  
    %saveas(gcf, "fig2.png");
end

