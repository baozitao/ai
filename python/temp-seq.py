#!/usr/bin/env python
# coding: utf-8

# In[1]:


import os 
data_dir = '../temp-data'
fname = os.path.join(data_dir, 'jena_climate_2009_2016.csv') 
f = open(fname)
data = f.read()
f.close() 
lines = data.split('\n')
header = lines[0].split(',')
lines = lines[1:] 
print(header)
print(len(lines))


# In[7]:


import numpy as np 
float_data = np.zeros((len(lines), len(header) - 1))
for i, line in enumerate(lines):
 values = [float(x) for x in line.split(',')[1:]]
 float_data[i, :] = values
    
from matplotlib import pyplot as plt 
temp = float_data[:, 1] # 温度（单位：摄氏度）
plt.plot(range(len(temp)), temp)


# In[6]:


plt.plot(range(1440), temp[:1440])


# In[ ]:




