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

import os
from PIL import Image
from IPython.display import display

import warnings
warnings.filterwarnings('ignore')

train_transform = transforms.Compose([
    transforms.Resize(224),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
])

test_transform = transforms.Compose([
    transforms.Resize(224),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    # Same value range as the network is trained on.
])

# File directory for the images.
root = '~/Documents/MATLAB/Differences in regions of interest/Cleaned data/ResampleDensities/Scene_10/'

# Complete scenes 9,10

train_data = datasets.ImageFolder((root + 'train'), transform=train_transform)
test_data = datasets.ImageFolder((root + 'test'), transform=test_transform)


train_loader = DataLoader(train_data, batch_size=10, shuffle=True)
test_loader = DataLoader(test_data, batch_size=10, shuffle=True)

class_names = train_data.classes

for images, labels in train_loader:
    break

im = make_grid(images, nrow=5)

inv_normalize = transforms.Normalize(
    mean=[-0.485/0.229, -0.456/0.224, -0.406/0.225],
    std=[1/0.229, 1/0.224, 1/0.225]
)
im_inv = inv_normalize(im)

plt.figure(figsize=(12, 4))
plt.imshow(np.transpose(im_inv, (1, 2, 0)))
plt.show()




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

CNNmodel = ConvolutionalNetwork()

criterion = nn.CrossEntropyLoss()
optimizer = torch.optim.Adam(CNNmodel.parameters(), lr=0.00001)



print(CNNmodel)

for p in CNNmodel.parameters():
    print(p.numel())


import time
start_time = time.time()

epochs = 5

# Limits on num of batches
max_trn_batch = 7500 # A single batch is 10 images -> 75,000 images
max_tst_batch = 2500 # 25000 images.



train_losses = []
test_losses = []
train_correct = []
test_correct = []

for i in range(epochs):
    trn_corr = 0
    tst_corr = 0
    for b, (X_train, y_train) in enumerate(train_loader):

        # Optional limit number of batches
        if b == max_trn_batch:
            break
        b += 1
        y_pred = CNNmodel(X_train)
        loss = criterion(y_pred, y_train)

        # Tally the number of correct predictions
        predicted = torch.max(y_pred, 1)[1]
        batch_corr = (predicted == y_train).sum()
        trn_corr += batch_corr

        # update parameters
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        # report print
        if b%250 == 0:
            current_time = time.time() - start_time
            print(f'Epoch: {i} Time: {current_time} Loss: {loss.item():.4f}')

    train_losses.append(loss)
    train_correct.append(trn_corr)



    with torch.no_grad():
        for b, (X_test, y_test) in enumerate(test_loader):

            # Optional
            if b == max_tst_batch:
                break
            y_val = CNNmodel(X_test)
            predicted = torch.max(y_val, 1)[1]
            batch_corr = (predicted == y_test).sum()
            tst_corr += batch_corr

    loss = criterion(y_val, y_test)
    test_losses.append(loss)
    test_correct.append(tst_corr)



total_time = time.time() - start_time
print(f'Total time: {total_time} seconds.')


#torch.save(CNNmodel.state_dict(), 'CNNScene_1_test.pt')

torch.save(CNNmodel.state_dict(), 'Scene_10.pt')
#
plt.plot(torch.tensor(train_losses).numpy(), label='train loss')
plt.plot(torch.tensor(test_losses).numpy(), label='test loss')
plt.title('Loss at the end of each epoch')
plt.legend()
plt.show()
#
plt.plot([t/750 for t in train_correct], label='train accuracy')
plt.plot([t/250 for t in test_correct], label='test accuracy')
plt.title('Accuracy at the end of each epoch')
plt.legend()
plt.show()


accuracy = (100*test_correct[-1].item()/25000) # Final number relates to amount of images trained.
print(f'Test Accuracy: {accuracy}')

# train on the sound and no sound.
# Focus on specific conditions.

