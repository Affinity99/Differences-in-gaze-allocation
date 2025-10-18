
# Standard imports
import torch
import torch.nn as nn
import torch.nn.functional as F
from torch.utils.data import DataLoader
from torchvision import datasets, transforms, models

from torchvision.utils import make_grid

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import time

import os
from PIL import Image
from IPython.display import display

import warnings
warnings.filterwarnings('ignore')

import random

# To load in pretrained weights and biases, you must first have the architecture of the CNN class structured.
class ConvolutionalNetwork(nn.Module):

    def __init__(self):
        super().__init__()
        self.conv1 = nn.Conv2d(3,6, 5, 2)
        self.conv2 = nn.Conv2d(6, 16, 5,2, padding=2)
        self.conv3 = nn.Conv2d(16,384, 3,1, padding=2)
        self.conv4 = nn.Conv2d(384, 384, 3, 1, padding=2)
        self.conv5 = nn.Conv2d(384, 256, 3, 1, padding=2)
        self.fc1 = nn.Linear(32256, 4096)
        self.fc2 = nn.Linear(in_features=4096, out_features=1000)
        self.fc3 = nn.Linear(in_features=1000, out_features=120)
        self.fc4 = nn.Linear(in_features=120, out_features=84)
        self.fc5 = nn.Linear(in_features=84, out_features=5)

    def forward(self, X):
        X = F.relu(self.conv1(X))
        X = F.max_pool2d(X, 3, 2)
        X = F.relu(self.conv2(X))
        X = F.max_pool2d(X, 3, 2)
        X = F.relu(self.conv3(X))
        X = F.relu(self.conv4(X))
        X = F.relu(self.conv5(X))
        X = F.max_pool2d(X, 3, 2)
        X = X.view(X.size(0), -1)
        X = F.relu(self.fc1(X))
        X = F.relu(self.fc2(X))
        X = F.relu(self.fc3(X))
        X = F.relu(self.fc4(X))
        X = self.fc5(X)
        return F.log_softmax(X, dim=1)

# Creates the model.
CNNmodel = ConvolutionalNetwork()

# Load in the pretrained model parameters.
df = '/Users/jackprosser/Documents/MATLAB/Differences in regions of interest/Cleaned Data/Scene_1.pt'
CNNmodel.load_state_dict(torch.load(df))

criterion = nn.CrossEntropyLoss()
optimizer = torch.optim.Adam(CNNmodel.parameters(), lr=0.00001)


# Putting the model into eval mode.
CNNmodel.eval()

# Loading in data.

test_transform = transforms.Compose([
    transforms.Resize(224),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    # Same value range as the network is trained on.
])

root = '~/Documents/MATLAB/Differences in regions of interest/Cleaned data/ResampleDensities/Scene_1/'
test_data = datasets.ImageFolder(os.path.join(root, 'test'), transform=test_transform)
test_loader = DataLoader(test_data, batch_size=10, shuffle=True) # see if this shuffles the labels.

class_names = test_data.classes
print(class_names)

# CNN

# Below prints out all the parameters and the elements / number of connections within the network.
for param in CNNmodel.parameters():
    print(param.numel())
    param.requires_grad = False

# Beginning with the network.


test_losses = []
test_correct = []

epochs = 1 # set number of epochs for test loop.
max_tst_batch = 100 # Loads in 25000 images or the whole test data. If you want to limit data amount etc. 
# Time start
start_time = time.time()

# This will normalize the photo for it to be saved into its corresponding folder type.
inv_normalize = transforms.Normalize(
    mean=[-0.485 / 0.229, -0.456 / 0.224, -0.406 / 0.225],
    std=[1 / 0.229, 1 / 0.224, 1 / 0.225])


for i in range(epochs):
    tst_corr = 0
    # Run the testing batches
    with torch.no_grad():
        for b, (X_test, y_test) in enumerate(test_loader):


            # Apply the model
            y_val = CNNmodel(X_test)

            # Tally the number of correct predictions
            predicted = torch.max(y_val.data, 1)[1] # Original code to get predicted outcome of image for testing CNN.


            # print(predicted) E.G: [1, 1, 4, 3, 1, 2, 2, 2, 2, 3] - Labels per image.

            tst_corr += (predicted == y_test).sum()




            # Print interim results
            if b % 50 == 0 and b != 0:
                current_time = time.time() - start_time
                print(f'Epoch: {i} Time: {current_time} accuracy: {tst_corr.item() * 100 / (10 * b):7.3f}%')
        #       print(f'epoch: {i:2}  batch: {b:4} [{10 * b:6}/2500]  loss: {loss.item():10.8f}  \

            if b == max_tst_batch:
                break

    loss = criterion(y_val, y_test)
    test_losses.append(loss)
    test_correct.append(tst_corr)






# Next steps are to shuffle my test set and their labels. and then feed through and test them.
# Images and their labels need to be shuffled randomly.
# As such the network should not be able to train accordingly.














