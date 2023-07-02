#!/usr/bin/env python
# coding: utf-8

# In[2]:


from keras import models
import numpy as np
import matplotlib.pyplot as plt
from keras.utils import image_utils
from keras.models import load_model


# In[3]:


model = load_model('cats_and_dogs_small_2.h5')
model.summary()


# In[7]:


# 准备一张图像
img_path = './newCatAndDog/test/cats/cat.4001.jpg'


img = image_utils.load_img(img_path, target_size=(150, 150))
img_tensor = image_utils.img_to_array(img)
img_tensor = np.expand_dims(img_tensor, axis=0)
img_tensor /= 255.
# 其形状为 (1, 150, 150, 3)
print(img_tensor.shape)
plt.imshow(img_tensor[0])
plt.show()


# In[20]:


layer_outputs = [layer.output for layer in model.layers[:8]]
activation_model = models.Model(inputs=model.input, outputs=layer_outputs)


# In[33]:


activations = activation_model.predict(img_tensor)
first_layer_activation = activations[0]
first_layer_activation.shape


# In[30]:


plt.matshow(first_layer_activation[0, :, :, 4], cmap='viridis')


# In[34]:


plt.matshow(first_layer_activation[0, :, :, 7], cmap='viridis')


# In[41]:


layer_names = []
for layer in model.layers[:8]:
    layer_names.append(layer.name)

images_per_row = 16
for layer_name, layer_activation in zip(layer_names, activations):
    n_features = layer_activation.shape[-1]
    size = layer_activation.shape[1]
    n_cols = n_features // images_per_row
    display_grid = np.zeros((size * n_cols, images_per_row * size))
    for col in range(n_cols):
        for row in range(images_per_row):
            channel_image = layer_activation[0,
                                             :, :, col * images_per_row + row]
            channel_image -= channel_image.mean()
            channel_image /= channel_image.std()
            channel_image *= 64
            channel_image += 128
            channel_image = np.clip(channel_image, 0, 255).astype('uint8')
            display_grid[col * size: (col + 1) * size,
                         row * size: (row + 1) * size] = channel_image
    scale = 1. / size
    plt.figure(figsize=(scale * display_grid.shape[1],
                        scale * display_grid.shape[0]))
    plt.title(layer_name)
    plt.grid(False)
    plt.imshow(display_grid, aspect='auto', cmap='viridis')


# In[ ]:
