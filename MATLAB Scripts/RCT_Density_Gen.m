% Parameters for RCT generation with imgaussfiltering applied to depict region of fixation. 
gen_maps = 10000; % will be 50,000 per scene. Just generate 10 for now to practice with.
fix_points = 5;
PixelsPerDVA = 43;

Set = ["Set 1", "Set 2", "Set 3", "Set 4", "Set 5"];
I = [1920, 1080]; % Image size for regions to generate from and to. 
for x = 1:max(size(Set))
    for smp = 1:gen_maps
        fixation_memory = []; % reset for every map generated.
        % generate two random numbers:
        % random x cords
        x_cord = randi(1920, [5,1]); % Generates 5 random x cords between 1-1920.
        % random y cords
        y_cord = randi(1080, [5,1]); % Generates 5 random y cords between 1-1080.
        % merge into a list.
        % then create density map.
        for fix_mem = 1:fix_points
            for j = 1:2 % number of columns.
                if j == 1
                    fixation_memory(fix_mem,j) = x_cord(fix_mem,1);
                else
                    fixation_memory(fix_mem,j) = y_cord(fix_mem, 1);
                end
            end
        end
    
        % Now we have our fixations in memory. Generate density maps. 
        % Create our completely blacked out images.
    
        heatmap = zeros(I(2),I(1)); % Creates a Matrix of zeros.
    
        % Loop through our fixation points.
        for i = 1:fix_points
            try
                heatmap(round(fixation_memory(i,2)), round(fixation_memory(i,1))) = heatmap(round(fixation_memory(i,2)), round(fixation_memory(i,1))) + 1; 
            catch
                warning('fix out')
            end
        end
    
        density = imgaussfilt(heatmap,PixelsPerDVA);
        density = density / max(density(:)); % to save images as 0's or 1's.
        imwrite(density, ['ResampleDensities/Scene_1/RCT/Random_Gen_Fix/' num2str(Set(x)) '/' 'SAMP' num2str(smp) '.png']);
    end
end


% 
% tiledlayout(2,5)
% a = imread("SAMP1.png");
% a2 = imread("SAMP2.png");
% a3 = imread("SAMP3.png");
% a4 = imread("SAMP4.png");
% a5 = imread("SAMP5.png");
% a6 = imread("SAMP6.png");
% a7 = imread("SAMP7.png");
% a8 = imread("SAMP8.png");
% a9 = imread("SAMP9.png");
% a10 = imread("SAMP10.png");
% 
% nexttile
% imshow(a)
% title("Sample 1")
% nexttile
% imshow(a2)
% title("Sample 2")
% nexttile
% imshow(a3)
% title("Sample 3")
% nexttile
% imshow(a4)
% title("Sample 4")
% nexttile
% imshow(a5)
% title("Sample 5")
% nexttile
% imshow(a6)
% title("Sample 6")
% nexttile
% imshow(a7)
% title("Sample 7")
% nexttile
% imshow(a8)
% title("Sample 8")
% nexttile
% imshow(a9)
% title("Sample 9")
% nexttile
% imshow(a10)
% title("Sample 10")
% 

%montage(image_list)
