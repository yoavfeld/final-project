

import scipy.io as sio
import matplotlib.pyplot as plt
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.svm import SVC
from tensorflow import set_random_seed
from numpy.random import seed
seed(1)
set_random_seed(1)

XTrainFile = '/Users/yoav.feldman/fmri/final-project/scripts/tfMRI/isfc_data/isfc_7T_movie2/train/net_9/part_2/X.mat'
YTrainFile = '/Users/yoav.feldman/fmri/final-project/scripts/tfMRI/isfc_data/isfc_7T_movie2/train/net_9/part_2/Y_9_classes.mat'
XTestFile = '/Users/yoav.feldman/fmri/final-project/scripts/tfMRI/isfc_data/isfc_7T_movie2/test/net_9/part_2/X.mat'
YTestFile = '/Users/yoav.feldman/fmri/final-project/scripts/tfMRI/isfc_data/isfc_7T_movie2/test/net_9/part_2/Y_9_classes.mat'
X_train = np.array(sio.loadmat(XTrainFile)['X'])
y_train = np.array(np.ravel(sio.loadmat(YTrainFile)['Y_9_classes']))
X_test = np.array(sio.loadmat(XTestFile)['X'])
y_test = np.array(np.ravel(sio.loadmat(YTestFile)['Y_9_classes']))


#XFile = '/Users/yoav.feldman/fmri/final-project/scripts/tfMRI/fc_data/fc_7T_movie2/net_9/part_2/X.mat'
#YFile = '/Users/yoav.feldman/fmri/final-project/scripts/tfMRI/fc_data/fc_7T_movie2/net_9/part_2/Y_9_classes.mat'
#X = np.array(sio.loadmat(XFile)['X'])
#Y = sio.loadmat(YFile)['Y_9_classes']
#Y = np.array(np.ravel(Y))
#X_train, X_test, y_train, y_test = train_test_split(X, Y, test_size = 0.15)


svc = SVC(kernel='rbf', gamma='scale') #SVC(kernel='linear', C=0.3)
svc.fit(X_train, y_train)

y_pred = svc.predict(X_test)

print("Accuracy: {}%".format(svc.score(X_test, y_test) * 100 ))
print(confusion_matrix(y_test,y_pred))