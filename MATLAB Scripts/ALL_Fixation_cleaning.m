%% Load all files into the program.

close all

dfs = ["BBd_FR", "IIs_FR", "JJc_FR", "JJS_FR", "MLS_FR", "NM1_FR"];

for i = 1:max(size(dfs))
    file = dfs(i) + '.mat';
    load(file)
end

% File for heatmaps
file = '../images/bells.png';
I = imread(file);
%imshow(I)





%% Sorting all data into scenes and conditions.
all_fixations = [BBd_mat;IIs_mat;JJc_mat;JJS_mat;MLS_mat;NM1_mat];

% Now Organise the fixations by scenes. 
scene_1 = zeros(max(size(all_fixations)),min(size(all_fixations)));
scene_2 = zeros(max(size(all_fixations)),min(size(all_fixations)));
scene_3 = zeros(max(size(all_fixations)),min(size(all_fixations)));
scene_4 = zeros(max(size(all_fixations)),min(size(all_fixations)));
scene_5 = zeros(max(size(all_fixations)),min(size(all_fixations)));
scene_6 = zeros(max(size(all_fixations)),min(size(all_fixations)));
scene_7 = zeros(max(size(all_fixations)),min(size(all_fixations)));
scene_8 = zeros(max(size(all_fixations)),min(size(all_fixations)));
scene_9 = zeros(max(size(all_fixations)),min(size(all_fixations)));
scene_10 = zeros(max(size(all_fixations)),min(size(all_fixations)));

for i = 1:max(size(all_fixations))

    if all_fixations(i,4) == 1
        scene_1(i,:) = all_fixations(i,:);
    elseif all_fixations(i,4) == 2
        scene_2(i,:) = all_fixations(i,:);
    elseif all_fixations(i,4) == 3
        scene_3(i,:) = all_fixations(i,:);
    elseif all_fixations(i,4) == 4
        scene_4(i,:) = all_fixations(i,:);
    elseif all_fixations(i,4) == 5
        scene_5(i,:) = all_fixations(i,:);
    elseif all_fixations(i,4) == 6
        scene_6(i,:) = all_fixations(i,:);
    elseif all_fixations(i,4) == 7
        scene_7(i,:) = all_fixations(i,:);
    elseif all_fixations(i,4) == 8
        scene_8(i,:) = all_fixations(i,:);
    elseif all_fixations(i,4) == 9
        scene_9(i,:) = all_fixations(i,:);
    elseif all_fixations(i,4) == 10
        scene_10(i,:) = all_fixations(i,:);
    end
end

% Creation of all the scene fixations are here. ready to sub_sample and
% create density maps.

scene_1 = reshape(nonzeros(scene_1),[],5);
scene_2 = reshape(nonzeros(scene_2),[],5);
scene_3 = reshape(nonzeros(scene_3),[],5);
scene_4 = reshape(nonzeros(scene_4),[],5);
scene_5 = reshape(nonzeros(scene_5),[],5);
scene_6 = reshape(nonzeros(scene_6),[],5);
scene_7 = reshape(nonzeros(scene_7),[],5);
scene_8 = reshape(nonzeros(scene_8),[],5);
scene_9 = reshape(nonzeros(scene_9),[],5);
scene_10 = reshape(nonzeros(scene_10),[],5);

%To analyse trial Fixation Count and generate a mean number of fixations.
scene_1_analysis = round(scene_1);

temp_scene_1_x = unique(scene_1_analysis(:,1));
out = histc(scene_1_analysis(:,1), temp_scene_1_x);
add = 0;
for r = 1:max(size(out))
    add = add + out(r,1);
end
mean = add/[max(size(out))];


disp(mean)
disp([temp_scene_1_x, out])



% new variables of only fixation and condition
scene_1 = [scene_1(:,2),scene_1(:,3),scene_1(:,5)];
scene_2 = [scene_2(:,2),scene_2(:,3),scene_2(:,5)];
scene_3 = [scene_3(:,2),scene_3(:,3),scene_3(:,5)];
scene_4 = [scene_4(:,2),scene_4(:,3),scene_4(:,5)];
scene_5 = [scene_5(:,2),scene_5(:,3),scene_5(:,5)];
scene_6 = [scene_6(:,2),scene_6(:,3),scene_6(:,5)];
scene_7 = [scene_7(:,2),scene_7(:,3),scene_7(:,5)];
scene_8 = [scene_8(:,2),scene_8(:,3),scene_8(:,5)];
scene_9 = [scene_9(:,2),scene_9(:,3),scene_9(:,5)];
scene_10 = [scene_10(:,2),scene_10(:,3),scene_10(:,5)];

%% Create the condition matrixs,
% for scene 1, all conditions
scene_1_1 = zeros(max(size(scene_1)), min(size(scene_1)));
scene_1_2 = zeros(max(size(scene_1)), min(size(scene_1)));
scene_1_3 = zeros(max(size(scene_1)), min(size(scene_1)));
scene_1_4 = zeros(max(size(scene_1)), min(size(scene_1)));
scene_1_5 = zeros(max(size(scene_1)), min(size(scene_1)));

for i = 1:max(size(scene_1))
    if scene_1(i,3) == 1
        scene_1_1(i,:) = scene_1(i,:);
    elseif scene_1(i,3) == 2
        scene_1_2(i,:) = scene_1(i,:);
    elseif scene_1(i,3) == 3
        scene_1_3(i,:) = scene_1(i,:);
    elseif scene_1(i,3) == 4
        scene_1_4(i,:) = scene_1(i,:);
    elseif scene_1(i,3) == 5
        scene_1_5(i,:) = scene_1(i,:);
    end
end

% Removes all zeros and reshapes into correct columns.
scene_1_1 = reshape(nonzeros(scene_1_1),[],3);
scene_1_2 = reshape(nonzeros(scene_1_2),[],3);
scene_1_3 = reshape(nonzeros(scene_1_3),[],3);
scene_1_4 = reshape(nonzeros(scene_1_4),[],3);
scene_1_5 = reshape(nonzeros(scene_1_5),[],3);

% removes condition column at the end so only fixations remain per
% condition.
scene_1_1 = scene_1_1(:,1:2);
scene_1_2 = scene_1_2(:,1:2);
scene_1_3 = scene_1_3(:,1:2);
scene_1_4 = scene_1_4(:,1:2);
scene_1_5 = scene_1_5(:,1:2);

%% Scene 2 Data Generation:

scene_2_1 = zeros(max(size(scene_2)), min(size(scene_2)));
scene_2_2 = zeros(max(size(scene_2)), min(size(scene_2)));
scene_2_3 = zeros(max(size(scene_2)), min(size(scene_2)));
scene_2_4 = zeros(max(size(scene_2)), min(size(scene_2)));
scene_2_5 = zeros(max(size(scene_2)), min(size(scene_2)));

for i = 1:max(size(scene_2))
    if scene_2(i,3) == 1
        scene_2_1(i,:) = scene_2(i,:);
    elseif scene_2(i,3) == 2
        scene_2_2(i,:) = scene_2(i,:);
    elseif scene_2(i,3) == 3
        scene_2_3(i,:) = scene_2(i,:);
    elseif scene_2(i,3) == 4
        scene_2_4(i,:) = scene_2(i,:);
    elseif scene_2(i,3) == 5
        scene_2_5(i,:) = scene_2(i,:);
    end
end

% Removes all zeros and reshapes into correct columns.
scene_2_1 = reshape(nonzeros(scene_2_1),[],3);
scene_2_2 = reshape(nonzeros(scene_2_2),[],3);
scene_2_3 = reshape(nonzeros(scene_2_3),[],3);
scene_2_4 = reshape(nonzeros(scene_2_4),[],3);
scene_2_5 = reshape(nonzeros(scene_2_5),[],3);

% removes condition column at the end so only fixations remain per
% condition.
scene_2_1 = scene_2_1(:,1:2);
scene_2_2 = scene_2_2(:,1:2);
scene_2_3 = scene_2_3(:,1:2);
scene_2_4 = scene_2_4(:,1:2);
scene_2_5 = scene_2_5(:,1:2);

%% Scene 3 Data Generation:

scene_3_1 = zeros(max(size(scene_3)), min(size(scene_3)));
scene_3_2 = zeros(max(size(scene_3)), min(size(scene_3)));
scene_3_3 = zeros(max(size(scene_3)), min(size(scene_3)));
scene_3_4 = zeros(max(size(scene_3)), min(size(scene_3)));
scene_3_5 = zeros(max(size(scene_3)), min(size(scene_3)));

for i = 1:max(size(scene_3))
    if scene_3(i,3) == 1
        scene_3_1(i,:) = scene_3(i,:);
    elseif scene_3(i,3) == 2
        scene_3_2(i,:) = scene_3(i,:);
    elseif scene_3(i,3) == 3
        scene_3_3(i,:) = scene_3(i,:);
    elseif scene_3(i,3) == 4
        scene_3_4(i,:) = scene_3(i,:);
    elseif scene_3(i,3) == 5
        scene_3_5(i,:) = scene_3(i,:);
    end
end

% Removes all zeros and reshapes into correct columns.
scene_3_1 = reshape(nonzeros(scene_3_1),[],3);
scene_3_2 = reshape(nonzeros(scene_3_2),[],3);
scene_3_3 = reshape(nonzeros(scene_3_3),[],3);
scene_3_4 = reshape(nonzeros(scene_3_4),[],3);
scene_3_5 = reshape(nonzeros(scene_3_5),[],3);

% removes condition column at the end so only fixations remain per
% condition.
scene_3_1 = scene_3_1(:,1:2);
scene_3_2 = scene_3_2(:,1:2);
scene_3_3 = scene_3_3(:,1:2);
scene_3_4 = scene_3_4(:,1:2);
scene_3_5 = scene_3_5(:,1:2);

%% Scene 4 Data Generation:

scene_4_1 = zeros(max(size(scene_4)), min(size(scene_4)));
scene_4_2 = zeros(max(size(scene_4)), min(size(scene_4)));
scene_4_3 = zeros(max(size(scene_4)), min(size(scene_4)));
scene_4_4 = zeros(max(size(scene_4)), min(size(scene_4)));
scene_4_5 = zeros(max(size(scene_4)), min(size(scene_4)));

for i = 1:max(size(scene_4))
    if scene_4(i,3) == 1
        scene_4_1(i,:) = scene_4(i,:);
    elseif scene_4(i,3) == 2
        scene_4_2(i,:) = scene_4(i,:);
    elseif scene_4(i,3) == 3
        scene_4_3(i,:) = scene_4(i,:);
    elseif scene_4(i,3) == 4
        scene_4_4(i,:) = scene_4(i,:);
    elseif scene_4(i,3) == 5
        scene_4_5(i,:) = scene_4(i,:);
    end
end

% Removes all zeros and reshapes into correct columns.
scene_4_1 = reshape(nonzeros(scene_4_1),[],3);
scene_4_2 = reshape(nonzeros(scene_4_2),[],3);
scene_4_3 = reshape(nonzeros(scene_4_3),[],3);
scene_4_4 = reshape(nonzeros(scene_4_4),[],3);
scene_4_5 = reshape(nonzeros(scene_4_5),[],3);

% removes condition column at the end so only fixations remain per
% condition.
scene_4_1 = scene_4_1(:,1:2);
scene_4_2 = scene_4_2(:,1:2);
scene_4_3 = scene_4_3(:,1:2);
scene_4_4 = scene_4_4(:,1:2);
scene_4_5 = scene_4_5(:,1:2);

%% Scene 5 Data Generation:

scene_5_1 = zeros(max(size(scene_5)), min(size(scene_5)));
scene_5_2 = zeros(max(size(scene_5)), min(size(scene_5)));
scene_5_3 = zeros(max(size(scene_5)), min(size(scene_5)));
scene_5_4 = zeros(max(size(scene_5)), min(size(scene_5)));
scene_5_5 = zeros(max(size(scene_5)), min(size(scene_5)));

for i = 1:max(size(scene_5))
    if scene_5(i,3) == 1
        scene_5_1(i,:) = scene_5(i,:);
    elseif scene_5(i,3) == 2
        scene_5_2(i,:) = scene_5(i,:);
    elseif scene_5(i,3) == 3
        scene_5_3(i,:) = scene_5(i,:);
    elseif scene_5(i,3) == 4
        scene_5_4(i,:) = scene_5(i,:);
    elseif scene_5(i,3) == 5
        scene_5_5(i,:) = scene_5(i,:);
    end
end

% Removes all zeros and reshapes into correct columns.
scene_5_1 = reshape(nonzeros(scene_5_1),[],3);
scene_5_2 = reshape(nonzeros(scene_5_2),[],3);
scene_5_3 = reshape(nonzeros(scene_5_3),[],3);
scene_5_4 = reshape(nonzeros(scene_5_4),[],3);
scene_5_5 = reshape(nonzeros(scene_5_5),[],3);

% removes condition column at the end so only fixations remain per
% condition.
scene_5_1 = scene_5_1(:,1:2);
scene_5_2 = scene_5_2(:,1:2);
scene_5_3 = scene_5_3(:,1:2);
scene_5_4 = scene_5_4(:,1:2);
scene_5_5 = scene_5_5(:,1:2);

%% Scene 6 Data Generation:

scene_6_1 = zeros(max(size(scene_6)), min(size(scene_6)));
scene_6_2 = zeros(max(size(scene_6)), min(size(scene_6)));
scene_6_3 = zeros(max(size(scene_6)), min(size(scene_6)));
scene_6_4 = zeros(max(size(scene_6)), min(size(scene_6)));
scene_6_5 = zeros(max(size(scene_6)), min(size(scene_6)));

for i = 1:max(size(scene_6))
    if scene_6(i,3) == 1
        scene_6_1(i,:) = scene_6(i,:);
    elseif scene_6(i,3) == 2
        scene_6_2(i,:) = scene_6(i,:);
    elseif scene_6(i,3) == 3
        scene_6_3(i,:) = scene_6(i,:);
    elseif scene_6(i,3) == 4
        scene_6_4(i,:) = scene_6(i,:);
    elseif scene_6(i,3) == 5
        scene_6_5(i,:) = scene_6(i,:);
    end
end

% Removes all zeros and reshapes into correct columns.
scene_6_1 = reshape(nonzeros(scene_6_1),[],3);
scene_6_2 = reshape(nonzeros(scene_6_2),[],3);
scene_6_3 = reshape(nonzeros(scene_6_3),[],3);
scene_6_4 = reshape(nonzeros(scene_6_4),[],3);
scene_6_5 = reshape(nonzeros(scene_6_5),[],3);

% removes condition column at the end so only fixations remain per
% condition.
scene_6_1 = scene_6_1(:,1:2);
scene_6_2 = scene_6_2(:,1:2);
scene_6_3 = scene_6_3(:,1:2);
scene_6_4 = scene_6_4(:,1:2);
scene_6_5 = scene_6_5(:,1:2);

%% Scene 7 Data Generation:

scene_7_1 = zeros(max(size(scene_7)), min(size(scene_7)));
scene_7_2 = zeros(max(size(scene_7)), min(size(scene_7)));
scene_7_3 = zeros(max(size(scene_7)), min(size(scene_7)));
scene_7_4 = zeros(max(size(scene_7)), min(size(scene_7)));
scene_7_5 = zeros(max(size(scene_7)), min(size(scene_7)));

for i = 1:max(size(scene_7))
    if scene_7(i,3) == 1
        scene_7_1(i,:) = scene_7(i,:);
    elseif scene_7(i,3) == 2
        scene_7_2(i,:) = scene_7(i,:);
    elseif scene_7(i,3) == 3
        scene_7_3(i,:) = scene_7(i,:);
    elseif scene_7(i,3) == 4
        scene_7_4(i,:) = scene_7(i,:);
    elseif scene_7(i,3) == 5
        scene_7_5(i,:) = scene_7(i,:);
    end
end

% Removes all zeros and reshapes into correct columns.
scene_7_1 = reshape(nonzeros(scene_7_1),[],3);
scene_7_2 = reshape(nonzeros(scene_7_2),[],3);
scene_7_3 = reshape(nonzeros(scene_7_3),[],3);
scene_7_4 = reshape(nonzeros(scene_7_4),[],3);
scene_7_5 = reshape(nonzeros(scene_7_5),[],3);

% removes condition column at the end so only fixations remain per
% condition.
scene_7_1 = scene_7_1(:,1:2);
scene_7_2 = scene_7_2(:,1:2);
scene_7_3 = scene_7_3(:,1:2);
scene_7_4 = scene_7_4(:,1:2);
scene_7_5 = scene_7_5(:,1:2);

%% Scene 8 Data Generation:

scene_8_1 = zeros(max(size(scene_8)), min(size(scene_8)));
scene_8_2 = zeros(max(size(scene_8)), min(size(scene_8)));
scene_8_3 = zeros(max(size(scene_8)), min(size(scene_8)));
scene_8_4 = zeros(max(size(scene_8)), min(size(scene_8)));
scene_8_5 = zeros(max(size(scene_8)), min(size(scene_8)));

for i = 1:max(size(scene_8))
    if scene_8(i,3) == 1
        scene_8_1(i,:) = scene_8(i,:);
    elseif scene_8(i,3) == 2
        scene_8_2(i,:) = scene_8(i,:);
    elseif scene_8(i,3) == 3
        scene_8_3(i,:) = scene_8(i,:);
    elseif scene_8(i,3) == 4
        scene_8_4(i,:) = scene_8(i,:);
    elseif scene_8(i,3) == 5
        scene_8_5(i,:) = scene_8(i,:);
    end
end

% Removes all zeros and reshapes into correct columns.
scene_8_1 = reshape(nonzeros(scene_8_1),[],3);
scene_8_2 = reshape(nonzeros(scene_8_2),[],3);
scene_8_3 = reshape(nonzeros(scene_8_3),[],3);
scene_8_4 = reshape(nonzeros(scene_8_4),[],3);
scene_8_5 = reshape(nonzeros(scene_8_5),[],3);

% removes condition column at the end so only fixations remain per
% condition.
scene_8_1 = scene_8_1(:,1:2);
scene_8_2 = scene_8_2(:,1:2);
scene_8_3 = scene_8_3(:,1:2);
scene_8_4 = scene_8_4(:,1:2);
scene_8_5 = scene_8_5(:,1:2);

%% Scene 9 Data Generation:

scene_9_1 = zeros(max(size(scene_9)), min(size(scene_9)));
scene_9_2 = zeros(max(size(scene_9)), min(size(scene_9)));
scene_9_3 = zeros(max(size(scene_9)), min(size(scene_9)));
scene_9_4 = zeros(max(size(scene_9)), min(size(scene_9)));
scene_9_5 = zeros(max(size(scene_9)), min(size(scene_9)));

for i = 1:max(size(scene_9))
    if scene_9(i,3) == 1
        scene_9_1(i,:) = scene_9(i,:);
    elseif scene_9(i,3) == 2
        scene_9_2(i,:) = scene_9(i,:);
    elseif scene_9(i,3) == 3
        scene_9_3(i,:) = scene_9(i,:);
    elseif scene_9(i,3) == 4
        scene_9_4(i,:) = scene_9(i,:);
    elseif scene_9(i,3) == 5
        scene_9_5(i,:) = scene_9(i,:);
    end
end

% Removes all zeros and reshapes into correct columns.
scene_9_1 = reshape(nonzeros(scene_9_1),[],3);
scene_9_2 = reshape(nonzeros(scene_9_2),[],3);
scene_9_3 = reshape(nonzeros(scene_9_3),[],3);
scene_9_4 = reshape(nonzeros(scene_9_4),[],3);
scene_9_5 = reshape(nonzeros(scene_9_5),[],3);

% removes condition column at the end so only fixations remain per
% condition.
scene_9_1 = scene_9_1(:,1:2);
scene_9_2 = scene_9_2(:,1:2);
scene_9_3 = scene_9_3(:,1:2);
scene_9_4 = scene_9_4(:,1:2);
scene_9_5 = scene_9_5(:,1:2);
%% Scene 10 Data Generation:

scene_10_1 = zeros(max(size(scene_10)), min(size(scene_10)));
scene_10_2 = zeros(max(size(scene_10)), min(size(scene_10)));
scene_10_3 = zeros(max(size(scene_10)), min(size(scene_10)));
scene_10_4 = zeros(max(size(scene_10)), min(size(scene_10)));
scene_10_5 = zeros(max(size(scene_10)), min(size(scene_10)));

for i = 1:max(size(scene_10))
    if scene_10(i,3) == 1
        scene_10_1(i,:) = scene_10(i,:);
    elseif scene_10(i,3) == 2
        scene_10_2(i,:) = scene_10(i,:);
    elseif scene_10(i,3) == 3
        scene_10_3(i,:) = scene_10(i,:);
    elseif scene_10(i,3) == 4
        scene_10_4(i,:) = scene_10(i,:);
    elseif scene_10(i,3) == 5
        scene_10_5(i,:) = scene_10(i,:);
    end
end

% Removes all zeros and reshapes into correct columns.
scene_10_1 = reshape(nonzeros(scene_10_1),[],3);
scene_10_2 = reshape(nonzeros(scene_10_2),[],3);
scene_10_3 = reshape(nonzeros(scene_10_3),[],3);
scene_10_4 = reshape(nonzeros(scene_10_4),[],3);
scene_10_5 = reshape(nonzeros(scene_10_5),[],3);

% removes condition column at the end so only fixations remain per
% condition.
scene_10_1 = scene_10_1(:,1:2);
scene_10_2 = scene_10_2(:,1:2);
scene_10_3 = scene_10_3(:,1:2);
scene_10_4 = scene_10_4(:,1:2);
scene_10_5 = scene_10_5(:,1:2);

%% Creation of density maps.

% Arbitrarily set number of fixations per heatmap to 5. 
% May need to revisit this to understand why this number - average out
% no.fixations across each trial - ('fix_points' variable).

I = [1920, 1080]; % size of the screen.

% Scenes Done: S1, S2, S3, S4, S5, S6
% Scenes Current: S7
% Creating: train data: cond1, cond2, cond3, cond4, cond5
% Created: train data:   

% Creating: test data: cond1, cond2, cond3, cond4, cond5
% Created: test data: 



gen_maps = 1000; % How many maps we need to generate.
fix_points = 5;
PixelsPerDVA = 43; % Sets my Degrees of Visual angle. # 1.18cm for 

Cond = ["Cond 1", "Cond 2", "Cond 3", "Cond 4", "Cond 5"];


for x = 1:max(size(Cond))
    for smp = 1:gen_maps % If i need to generate more, change this.
        fixation_memory = []; % reset for every map generated.
        % Below creates the fixation index and 

        % out of all of the fixations in the condition (size), random
        % sample 5 indexs. add those indexs to the fixation memory.

        if x == 1
            tmp = randsample(1:max(size(scene_1_1)), fix_points);
            for i = 1:fix_points 
                fixation_memory(i,:) = scene_1_1(tmp(i),:);
            end
        elseif  x == 2
            tmp = randsample(1:max(size(scene_1_2)), fix_points);
            for i = 1:fix_points 
                fixation_memory(i,:) = scene_1_2(tmp(i),:);
            end
        elseif x == 3
            tmp = randsample(1:max(size(scene_1_3)), fix_points);
            for i = 1:fix_points 
                fixation_memory(i,:) = scene_1_3(tmp(i),:);
            end
        elseif x == 4
            tmp = randsample(1:max(size(scene_1_4)), fix_points);
            for i = 1:fix_points 
                fixation_memory(i,:) = scene_1_4(tmp(i),:);
            end
        elseif x == 5
            tmp = randsample(1:max(size(scene_1_5)), fix_points);
            for i = 1:fix_points 
                fixation_memory(i,:) = scene_1_5(tmp(i),:);
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

        % make density maps and save images.
        density = imgaussfilt(heatmap,PixelsPerDVA);
        density = density / max(density(:)); % to save images as 0's or 1's.
        imwrite(density, ['ResampleDensities/Scene_1/Validation/' num2str(Cond(x)) '/' 'SAMP' num2str(smp) '.png']);
    end
end

% Heatmap creation done in file "HeatMap".
