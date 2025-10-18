# Standard imports
import torch
import torch.nn as nn
import torch.nn.functional as F
from torch.utils.data import DataLoader
from torchvision.utils import save_image
from torchvision import datasets, transforms, models

from torchvision.utils import make_grid

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

import os
from PIL import Image
from IPython.display import display

import warnings
warnings.filterwarnings('ignore')


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

# Completed: 1,2,3,4,5,6,7,8,9
# Complete:  10.

# Load in the pretrained model parameters.
df = '/Users/jackprosser/Documents/MATLAB/Differences in regions of interest/Cleaned Data/Scene_10.pt'
CNNmodel.load_state_dict(torch.load(df))

criterion = nn.CrossEntropyLoss()
optimizer = torch.optim.Adam(CNNmodel.parameters(), lr=0.00001)

CNNmodel.eval()


# -------------------- Put in my data loaders for the network

test_transform = transforms.Compose([
    transforms.Resize(224),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    # Same value range as the network is trained on.
])


# Different sets and conditions for training and sorting.

diff_cond = ["Cond 1", "Cond 2", "Cond 3", "Cond 4", "Cond 5"]

root_test = '~/Documents/MATLAB/Differences in regions of interest/Cleaned data/ResampleDensities/Scene_1/RCT/Random_Gen_Fix/'
root_sort = '/Users/jackprosser/Documents/MATLAB/Differences in regions of interest/Cleaned data/ResampleDensities/Scene_10/RCT Sorted/'



test_data = datasets.ImageFolder(os.path.join(root_test), transform=test_transform)
test_loader = DataLoader(test_data, batch_size=10)


# This visualises the first set of data
for images, labels in test_loader:
    break

im = make_grid(images, nrow=5)

# Inverse normalize the images
inv_normalize = transforms.Normalize(
    mean=[-0.485/0.229, -0.456/0.224, -0.406/0.225],
    std=[1/0.229, 1/0.224, 1/0.225]
)
im_inv = inv_normalize(im)

plt.figure(figsize=(12, 4))
plt.imshow(np.transpose(im_inv, (1, 2, 0)))
plt.show()

## Predicted labels
pred_label_0 = []
pred_label_1 = []
pred_label_2 = []
pred_label_3 = []
pred_label_4 = []


## Running the prediction calculation on the batch.
b = 0
max_load = 5000 # Each is a batch of 10 images.
with torch.no_grad():
    for X_test, y_test in test_loader:
        b += 1
        y_val = CNNmodel(X_test)
        predicted = torch.max(y_val.data, 1)[1]
        #print(predicted)

        ##### ------------- Sort the images and save them into the corresponding folder.
        for img in range(len(X_test)): # Index into each image.
            #print(predicted[img])
            if predicted[img] == 0:
                pred_label_0.append(X_test[img])
            elif predicted[img] == 1:
                pred_label_1.append(X_test[img])
            elif predicted[img] == 2:
                pred_label_2.append(X_test[img])
            elif predicted[img] == 3:
                pred_label_3.append(X_test[img])
            elif predicted[img] == 4:
                pred_label_4.append(X_test[img])

        if b%100 == 0:
            print('Batch:', b)

        if b == max_load:
            break
print(len(pred_label_0), len(pred_label_1), len(pred_label_2), len(pred_label_3), len(pred_label_4))

## --------------------- Convert the list of organised tensor objects to saveable images.
## Because they are already organised, I can save them directly to their corresponding Cond folder.

conv_to_img = transforms.Compose([
    transforms.Normalize(mean=[-0.485 / 0.229, -0.456 / 0.224, -0.406 / 0.225],
                         std=[1 / 0.229, 1 / 0.224, 1 / 0.225]),
    transforms.Resize((1080, 1920)),
    transforms.ToPILImage(),
])

all_cond = [pred_label_0, pred_label_1, pred_label_2, pred_label_3, pred_label_4]


## This goes through and saves one image.
## Now I need to make this be able to save all images within the lists.,

## Variables
img_lab_new = 0 # Each Tensor being saved has a new name - new number.

for cond in range(len(diff_cond)): # Goes through all conditions
    print(cond)
    for tens in range(len(all_cond[cond])): # Goes through all tensors per condition.
        img = all_cond[cond][tens] # cond label then tensor number.
        img = conv_to_img(img)


        # If statement for correct file path saving.
        if cond == 0:
            img.save(root_sort + 'Cond 1/' + str(img_lab_new) + '.png')
            img_lab_new += 1
        elif cond == 1:
            img.save(root_sort + 'Cond 2/' + str(img_lab_new) + '.png')
            img_lab_new += 1
        elif cond == 2:
            img.save(root_sort + 'Cond 3/' + str(img_lab_new) + '.png')
            img_lab_new += 1
        elif cond == 3:
            img.save(root_sort + 'Cond 4/' + str(img_lab_new) + '.png')
            img_lab_new += 1
        elif cond == 4:
            img.save(root_sort + 'Cond 5/' + str(img_lab_new) + '.png')
            img_lab_new += 1




##### Example code for saving a single image - abstraction of problem for saving multiple.
# print(len(all_cond[0]))
# img = pred_label_4[0]
# print(img.shape)
# img = conv_to_img(img)
# img.show()
# img.save(root_sort + 'Cond 5/' + str(img_lab_new) + '.jpg')
