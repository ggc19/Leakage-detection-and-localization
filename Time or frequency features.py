# -*- coding: utf-8 -*-

import numpy as np
np.random.seed(1337)
from sklearn.metrics import confusion_matrix
from sklearn.metrics import roc_curve, auc
from sklearn.ensemble import RandomForestClassifier
from sklearn.tree import DecisionTreeClassifier
import scipy.io as scio
np.random.RandomState(2)
import time

'''-------------------------------------------read data-----------------------------------------'''
path1 = 'Data.mat'
path2 = 'Data_Feature.mat'
data1 = scio.loadmat(path1)
data2 = scio.loadmat(path2)
data1 = data1['Data']
data2 = data2['Data_Feature']
nb_features=13
Data = np.zeros((5481,nb_features+1))
Data[:,0]=data1[:,0]
Data[:,1:8]=data2[:,0:7]
Data[:,8:nb_features+1]=data2[:,8:nb_features+1]
indices = np.arange(Data.shape[0])
np.random.shuffle(indices)
Data=Data[indices,:]
Data_x = Data[:,1:nb_features+1]
Data_y = Data[:,0]
for i in range(Data_x.shape[1]):
    temp = Data_x[:,i]
    Data_x[:,i] = (temp-np.average(temp))/np.std(temp)
train_samples = int(Data_x.shape[0]*0.8)
test_samples = int(Data_x.shape[0]*0.2)
X_train = np.zeros((train_samples,Data_x.shape[1]))
y_train = np.zeros((train_samples,1))
X_test = np.zeros((test_samples,Data_x.shape[1]))
y_test = np.zeros((test_samples,1))
for i in range(train_samples):
    X_train[i,:] = Data_x[i,:]
    y_train[i,0] = Data_y[i]
for j in range(test_samples):
    i=j+train_samples
    X_test[j,:] = Data_x[i,:]
    y_test[j,0] = Data_y[i]

'''-------------------------------------RandomForest--------------------------------------'''
RF_clf=RandomForestClassifier(n_estimators=300, max_features='auto', criterion='entropy', bootstrap=True,random_state=2)
start = time.time()
RF_clf.fit(X_train, y_train)
print('Training time：',round(time.time() - start,4))
y_pred = RF_clf.predict(X_test)
y_prob = RF_clf.predict_proba(X_test)
RF_features = RF_clf.feature_importances_
con_matrix = confusion_matrix(y_test, y_pred)
accuracy = (con_matrix[0,0]+con_matrix[1,1])/len(y_pred)
specificity = (con_matrix[0,0])/(con_matrix[0,0]+con_matrix[0,1])
sensitivity = (con_matrix[1,1])/(con_matrix[1,0]+con_matrix[1,1])
fpr, tpr, thresholds = roc_curve(y_test, y_prob[:,1])
roc_auc = auc(fpr, tpr)
print('accuracy：%f, sensitivity： %f ,specificity： %f, roc_auc： %f'%(accuracy,sensitivity,specificity,roc_auc))

'''-----------------------------------------DecesionTree model----------------------------------'''
DT_clf = DecisionTreeClassifier(criterion='entropy',max_depth=50,min_samples_split=2,
                                min_samples_leaf=1,random_state=2)
start = time.time()
DT_clf.fit(X_train, y_train)
print('Training time：',round(time.time() - start,4))
y_pred = DT_clf.predict(X_test)
y_prob = DT_clf.predict_proba(X_test)
DT_con_matrix = confusion_matrix(y_test[:,0], y_pred)
print('DT accuracy：',(DT_con_matrix[0,0]+DT_con_matrix[1,1])/len(y_pred))
accuracy = (DT_con_matrix[0,0]+DT_con_matrix[1,1])/len(y_pred)
specificity = (DT_con_matrix[0,0])/(DT_con_matrix[0,0]+DT_con_matrix[0,1])
sensitivity = (DT_con_matrix[1,1])/(DT_con_matrix[1,0]+DT_con_matrix[1,1])
DT_fpr, DT_tpr, DT_thresholds = roc_curve(y_test[:,0], y_prob[:,1])
DT_roc_auc = auc(DT_fpr, DT_tpr)
print('accuracy：%f, sensitivity： %f ,specificity： %f, roc_auc： %f'%(accuracy,sensitivity,specificity,DT_roc_auc))
