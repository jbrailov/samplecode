import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'

import random
import numpy as np
import tensorflow as tf

random.seed(1693)
np.random.seed(1693)
tf.random.set_seed(1693)

# CODIO SOLUTION BEGIN
from tensorflow import keras
from keras.models import Sequential
from keras.layers import Dense, Dropout

import pandas as pd
import sklearn as sk
from sklearn.model_selection import train_test_split

DF = pd.read_excel("wine quality combined.xlsx")
y_raw = DF['quality']

DF=pd.get_dummies(DF, columns = ['category'])
x = DF.drop(['quality'], axis=1) 
print(x[15:18]) 

y=pd.get_dummies(y_raw, columns=['quality'])
print(y[15:18]) 


X_train, X_test, y_train, y_test = train_test_split(x, 
                                                    y, 
                                                    test_size=0.20, 
                                                    random_state=1693)

print(y_test[0:1]) #Q1-1-0


model = Sequential() 
model.add(Dense(units=18, 
                input_dim=13,
                activation='tanh' 
                )) 
model.add(Dropout(.23))
model.add(Dense(units=15,
                activation='relu' 
                )) 
model.add(Dense(7, 
                activation='softmax' 
                )) 

model.summary() 

model.compile(loss='BinaryCrossentropy',
              optimizer = 'adam',
              metrics=['accuracy'])

estimate = model.fit(X_train,
                     y_train, 
                     epochs=100,
                     verbose=0
                     )


test_loss, test_acc = model.evaluate(X_test, y_test)
print('test_acc:', test_acc) 
pred_prob = model.predict(x)
pred_class = pred_prob.argmax(axis=-1)+3
print(pred_class[15:18])
print(pred_class[15:18]==y_raw[15:18]) 
print(sum(pred_class == y_raw)/len(pred_class)) 
