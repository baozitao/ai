#!/usr/bin/env python
# coding: utf-8

# In[21]:


from keras.datasets import imdb
from keras.layers import preprocessing 
from keras_preprocessing import sequence
max_features = 10000 
maxlen = 20 
(x_train, y_train), (x_test, y_test) = imdb.load_data(
 num_words=max_features) 
x_train = sequence.pad_sequences(x_train, maxlen=maxlen) 
x_test = sequence.pad_sequences(x_test, maxlen=maxlen)


# In[27]:


from keras.models import Sequential 
from keras.layers import Flatten, Dense, Embedding 
model = Sequential()
model.add(Embedding(10000, 8, input_length=maxlen)) 
model.add(Flatten()) 
model.add(Dense(1, activation='sigmoid')) 
model.compile(optimizer='rmsprop', loss='binary_crossentropy', metrics=['acc']) 
model.summary() 


# In[26]:


history = model.fit(x_train, y_train, 
 epochs=10,
 batch_size=32, 
 validation_split=0.2)


# In[ ]:




