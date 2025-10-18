# Differences-in-gaze-allocation
This is a GitHub repository for my publication - Revealing and testing for differences in gaze allocation: A data driven approach.

A brief overview:

There are a few fundamentals that should be understood before using this code. Firstly, The MATLAB scripts are used to clean the Eyelink 1000 raw data files and extract only the meaningful fixations. Secondly, these fixations are then organised via scene and then their corresponding condition. Please note that this is all done automatically through the corresponding MATLAB script. Afterwards, for each scene and each condition, fixations from ALL participants are randomised and subsampled in order to create the randomised fixation maps. These maps are subsequently based on REAL data. This method of subsampling is used in order to generate different fixation maps for the Deep Neural Networks (DNNs) to train, test and validate on. The final MATLAB script allows for the generation of heatmaps using the matrices of any fixation map generated or sorted via the different scripts. The python scripts will either train the network, validate the network's accuracy or sort the predicted fixation maps into the condition the network believes they should be from. 

How to use the files:
