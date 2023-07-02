#!/usr/bin/env python
# coding: utf-8

# In[1]:


from keras.datasets import reuters 
(train_data, train_labels), (test_data, test_labels) = reuters.load_data( num_words=10000)


# In[20]:


import numpy as np 
def vectorize_sequences(sequences, dimension=10000):
     results = np.zeros((len(sequences), dimension))
     for i, sequence in enumerate(sequences):
         results[i, sequence] = 1.
     return results 

##### 将训练数据向量化
x_train = vectorize_sequences(train_data) 
x_test = vectorize_sequences(test_data) 

##### one-hot编码
from keras.utils.np_utils import to_categorical 
one_hot_train_labels = to_categorical(train_labels)
one_hot_test_labels = to_categorical(test_labels)

##### 将训练数据分为输入数据和验证数据
x_val = x_train[:1000]
partial_x_train = x_train[1000:] 
y_val = one_hot_train_labels[:1000]
partial_y_train = one_hot_train_labels[1000:]


# In[66]:


from keras import models
from keras import layers 
model = models.Sequential()
model.add(layers.Dense(25, activation='relu', input_shape=(10000,)))
# model.add(layers.Dense(128, activation='relu'))

model.add(layers.Dense(46, activation='softmax'))
model.compile(optimizer='rmsprop',
 loss='categorical_crossentropy',
 metrics=['accuracy'])

history = model.fit(partial_x_train,
 partial_y_train,
 epochs=30,
 batch_size=512,
 validation_data=(x_val, y_val))

import matplotlib.pyplot as plt 
loss = history.history['loss']
val_loss = history.history['val_loss'] 
epochs = range(1, len(loss) + 1) 
plt.plot(epochs, loss, 'bo', label='Training loss')
plt.plot(epochs, val_loss, 'b', label='Validation loss')
plt.title('Training and validation loss')
plt.xlabel('Epochs')
plt.ylabel('Loss')
plt.legend() 
plt.show()


# In[63]:





# In[33]:


predictions = model.predict(x_test)
predictions[0].shape
predictions[0]


# In[30]:





# In[ ]:




