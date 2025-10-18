dfs = ["BBd", "IIs", "JJc", "JJS", "MLS", "NM1"];
file = dfs(6) + '.asc';
l_file = dfs(6) + '.mat';


count_trials = 0;
count_fixation = 0;

if ~isempty(file)
    %% Count how many fixations are in the file:
    trial_ext = (["MSG", "START", "END", "EFIX"]);
    r_line = readlines(file); % reads the file, line by line.
    f_size = max(size(r_line)); % gets the size of the file    
    
    for i = 1:f_size
        c_s_line = split(r_line(i)); % Split current line.
        % Fixations we need are only those after the second start message has
        % been sent. 
        % Then we need the range between stand and end. All fixations falling
        % in this range need to be collected for the neural network. 


        tst_id = 0; % temp start trial id which measures if 1 or 2 start messages have been seen.

        % we essentially need to set this to a counter which resets after every
        % end message has been seen. 
        
        try
            if c_s_line(1) == trial_ext(1) && c_s_line(5) == trial_ext(2) % checks if start message.
                tst_id = 1; % first message has been seen. 
                %disp(tst_id)
                loop = 0;
                while loop ~= 1 
                    
                    if c_s_line(1) == trial_ext(1) && c_s_line(5) == trial_ext(3) % checks if end message.
                        loop = 1; % breaks loop
                    end
                    if loop ~= 1
                        i = i + 1; % Runs through the file.
                        c_s_line = split(r_line(i)); % Split new line.
                        if tst_id == 2 % Do not need to search for another start line.
                            % Collect all fixations now.
                            if c_s_line(1) == trial_ext(4) % is it a fixation line.
                                count_fixation = count_fixation + 1; %tallys fixations.
                            end
                        else
                            try
                                if c_s_line(1) == trial_ext(1) && c_s_line(5) == trial_ext(2) % is new line a start message.
                                  tst_id = 2; % Second start message found, start recording fixations.
                                end
                            catch
                            end
                        end
                    end
                end
            end
        catch
        end
    end
        %% Create the pre-determined matrix for fixations
        NM1_mat = zeros(count_fixation,3); % Creates a matrix of all 0's the size of fixation count.



%% Now I need to extract all fixations into the pre-defined matrix for fixations.
    fix_index = 0; % fixation index for list
    for i = 1:f_size
        c_s_line = split(r_line(i)); % Split current line.
        tst_id = 0;
        try
            if c_s_line(1) == trial_ext(1) && c_s_line(5) == trial_ext(2) % checks if start message.
                trial_id = c_s_line(4); % sets the trial id for final part of array.
                tst_id = 1; % first message has been seen. 
                %disp(tst_id)
                loop = 0;
                while loop ~= 1 
                       % error here
                    if c_s_line(1) == trial_ext(1) && c_s_line(5) == trial_ext(3) % checks if end message.
                        loop = 1; % breaks loop
                    end
                    % up till here     

                    if loop ~= 1
                        i = i + 1; % Runs through the file.
                        c_s_line = split(r_line(i)); % Split new line.
                        if tst_id == 2 % Do not need to search for another start line.
                               % Collect all fixations now.
                            if c_s_line(1) == trial_ext(4) % is it a fixation line.
                                fix_index = fix_index + 1;
                                disp(c_s_line(6))
                                disp(fix_index)
                                NM1_mat(fix_index,1) = trial_id; % trial id of fixation, 1st and 2nd start trial is the same.
                                NM1_mat(fix_index,2) = c_s_line(6); % extraction of x_average.
                                NM1_mat(fix_index,3) = c_s_line(7); % extraction of y_average.
                        
                            
    % ==== EXTRACT FIXATIONS IN THIS REGION ABOVE.
                            end
                        else
                            try
                                if c_s_line(1) == trial_ext(1) && c_s_line(5) == trial_ext(2) % is new line a start message.
                                  tst_id = 2; % Second start message found, start recording fixations.
                                end
                            catch
                            end
                        end
                    end
                end
            end
        catch
        end
    end
end


% Extraction of fixation done. Now I need to apply the condition to the
% trials etc from the responses. 

%% Appending the scene and sound condition to the current matrix of fixations. 


load(l_file) % load response file. 

% Loop over the response table associated with scene and condition. 

% associate every trial 1 with the first row. 
% then for every trial forward, apply the new line. 


for i = 1:size(RESPONSES.TABLE)
    for j = 1:max(size(NM1_mat))
        if NM1_mat(j,1) == i % checks to see if if the trail fixation = the line of the response table. 
            % if this is the case then append the scene and condition to
            % those rows.
            NM1_mat(j,4) = RESPONSES.TABLE(i,1);
            NM1_mat(j,5) = RESPONSES.TABLE(i,2);
            
        end
    end
end


%% now save the file into its own responses.

save('NM1_FR.mat','NM1_mat')







