df = '../images/bells.png';
df2 = '../images/bird.png';
df3 = '../images/chair.png';
df4 = '../images/clapping.png';
df5 = '../images/coins.png';
df6 = '../images/crickets.png';
df7 = '../images/helicopter.png';
df8 = '../images/ring.png';
df9 = '../images/steps.png';
df10 = '../images/waves.png';

main = imread(df); % Main image for the scene.
main2 = imread(df2); 
main3 = imread(df3); 
main4 = imread(df4); 
main5 = imread(df5); 
main6 = imread(df6); 
main7 = imread(df7); 
main8 = imread(df8); 
main9 = imread(df9); 
main10 = imread(df10); 

I = [1920,1080];

df_2 = '../Cleaned Data/ResampleDensities/Scene_10/RCT Sorted/';
cond = ["Cond 1", "Cond 2", "Cond 3", "Cond 4", "Cond 5"];

f_num = ["4594", "6825", "2604", "23458", "12519"];

n1 = str2num(f_num(1));
n2 = n1 + str2num(f_num(2));
n3 = n2 +  str2num(f_num(3));
n4 = n3 + str2num(f_num(4));
n5 = n4 + str2num(f_num(5));



%% Create a matrix of 0's in order to average pool out. 
base_1 = zeros(I(2), I(1));
base_2 = zeros(I(2), I(1));
base_3 = zeros(I(2), I(1));
base_4 = zeros(I(2), I(1));
base_5 = zeros(I(2), I(1));


%% Test on 1  image.
% This Grabs the first image of the RCT within cond 1. 
% a = 0;
% [I_2, map] = imread([df_2 num2str(cond(1)) '/' num2str(a) '.png']);
% I_2 = rgb2gray(I_2);
% for y = 1:I(2) % Equals the height of the image broken down.
%     for x = 1:I(1) % Equals the width of the image broken down.
%         base(y, x) = base(y,x) + I_2(y,x);
%     end
% end
% 
% density = I_2 / 2; % This halfs everything and rounds, i believe, up.


%%  loop for the file names to load in.

for i = 1:50000
    %% update the user on where the program is at.
    if mod(i,100) == 0
        disp('Image complete:')
        disp(i)
    end
    %% images and totaling everything.
    if i <= n1
        a = i - 1;
        [I_2, map] = imread([df_2 num2str(cond(1)) '/' num2str(a) '.png']);
        I_2 = double(rgb2gray(I_2));
        for y = 1:I(2) % Equals the height of the image broken down.
            for x = 1:I(1) % Equals the width of the image broken down.
                base_1(y, x) = base_1(y,x) + I_2(y,x);
            end
        end

    elseif i > n1 && i <= n2
        a = i - 1;
        [I_2, map] = imread([df_2 num2str(cond(2)) '/' num2str(a) '.png']);
        I_2 = double(rgb2gray(I_2));
        for y = 1:I(2) % Equals the height of the image broken down.
            for x = 1:I(1) % Equals the width of the image broken down.
                base_2(y, x) = base_2(y,x) + I_2(y,x);
            end
        end

    elseif  i > n2 && i <= n3
        a = i - 1;
        [I_2, map] = imread([df_2 num2str(cond(3)) '/' num2str(a) '.png']);
        I_2 = double(rgb2gray(I_2));
        for y = 1:I(2) % Equals the height of the image broken down.
            for x = 1:I(1) % Equals the width of the image broken down.
                base_3(y, x) = base_3(y,x) + I_2(y,x);
            end
        end

    elseif i  > n3 && i <= n4
        a = i - 1;
        [I_2, map] = imread([df_2 num2str(cond(4)) '/' num2str(a) '.png']);
        I_2 = double(rgb2gray(I_2));
        for y = 1:I(2) % Equals the height of the image broken down.
            for x = 1:I(1) % Equals the width of the image broken down.
                base_4(y, x) = base_4(y,x) + I_2(y,x);
            end
        end

    elseif i > n4 && i <= n5
        a = i - 1;
        [I_2, map] = imread([df_2 num2str(cond(5)) '/' num2str(a) '.png']);
        I_2 = double(rgb2gray(I_2));
        for y = 1:I(2) % Equals the height of the image broken down.
            for x = 1:I(1) % Equals the width of the image broken down.
                base_5(y, x) = base_5(y,x) + I_2(y,x);
            end
        end

    end
end


Density_1 = base_1 / str2num(f_num(1)); % Cond 1 - Congruent
Density_2 = base_2 / str2num(f_num(2)); % Cond 2 - Incongruent
Density_3 = base_3 / str2num(f_num(3)); % Cond 3 - Scrambled
Density_4 = base_4 / str2num(f_num(4)); % Cond 4 - Pink
Density_5 = base_5 / str2num(f_num(5)); % Cond 5 - No Sound
All_Sound_conds = (base_1 + base_2 + base_3 + base_4) / n4; % All 4 sounds averaged out.
No_congruent_cond = (base_2 + base_3 + base_4 + base_5) / (n5-n1); % All conditions minus congruent.


%% Normalization for each density map. 

Density_1_Sum = 0;
Density_2_Sum = 0;
Density_3_Sum = 0;
Density_4_Sum = 0;
Density_5_Sum = 0;
Density_No_Cong_Cond = 0;


for d = 1:I(2)
    for d2 = 1:I(1)
        Density_1_Sum = Density_1_Sum + Density_1(d,d2);
        Density_2_Sum = Density_2_Sum + Density_2(d,d2);
        Density_3_Sum = Density_3_Sum + Density_3(d,d2);
        Density_4_Sum = Density_4_Sum + Density_4(d,d2);
        Density_5_Sum = Density_5_Sum + Density_5(d,d2);
        Density_No_Cong_Cond = Density_No_Cong_Cond + No_congruent_cond(d,d2) ;
    end
end


Cond_1 = Density_1 / Density_1_Sum;
Cond_2 = Density_2 / Density_2_Sum;
Cond_3 = Density_3 / Density_3_Sum;
Cond_4 = Density_4 / Density_4_Sum;
Cond_5 = Density_5 / Density_5_Sum;
No_congruent_cond = No_congruent_cond / Density_No_Cong_Cond;

% Figures for each condition.
figure(1)
title('Congruent Sound');
heatmap = heatmap_overlay(main10, Cond_1);
imshow(heatmap)

figure(2)
title('Incongruent Sound');
heatmap_2 = heatmap_overlay(main10, Cond_2);
imshow(heatmap_2)

figure(3)
title('Scrambled Sound');
heatmap_3 = heatmap_overlay(main10, Cond_3);
imshow(heatmap_3)

figure(4)
title('Pink Sound');
heatmap_4 = heatmap_overlay(main10, Cond_4);
imshow(heatmap_4)

figure(5)
title('No Sound');
heatmap_5 = heatmap_overlay(main10, Cond_5);
imshow(heatmap_5)

figure(6)
title('No Congruent Sound')
heatmap_6 = heatmap_overlay(main10, No_congruent_cond);
imshow(heatmap_6)



% 
% % Figures for each condition.
% figure(1)
% title('Congruent Sound');
% heatmap = heatmap_overlay(main, Density_1);
% imshow(heatmap)
% 
% figure(2)
% title('Incongruent Sound');
% heatmap = heatmap_overlay(main, Density_2);
% imshow(heatmap)
% 
% figure(3)
% title('Scrambled Sound');
% heatmap = heatmap_overlay(main, Density_3);
% imshow(heatmap)
% 
% figure(4)
% title('Pink Sound');
% heatmap = heatmap_overlay(main, Density_4);
% imshow(heatmap)
% 
% figure(5)
% title('No Sound');
% heatmap = heatmap_overlay(main, Density_5);
% imshow(heatmap)
% 
% figure(6)
% title('All Sounds Condition')
% heatmap = heatmap_overlay(main, All_Sound_conds);
% imshow(heatmap)
% 
% figure(7)
% title('All Cond But Congruent Sound');
% heatmap = heatmap_overlay(main, No_congruent_cond);
% imshow(heatmap)