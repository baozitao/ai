#!/usr/bin/env python
# coding: utf-8

# In[27]:


# 相关库
from keras.preprocessing.image import ImageDataGenerator
from keras import optimizers
from keras import models
from keras import layers
import os
import shutil
import os
from PIL import Image
import matplotlib.pyplot as plt
import tensorflow as tf

# In[12]:


# 准备主要数据目录

# 准备训练数据目录
base_dir = '/home/baojt/work/tensor/newCatAndDog'

origin_cats_dir = '/home/baojt/work/tensor/CatAndDogDatasets/training_set/training_set/cats'
origin_dogs_dir = '/home/baojt/work/tensor/CatAndDogDatasets/training_set/training_set/dogs'

origin_test_cats_dir = '/home/baojt/work/tensor/CatAndDogDatasets/test_set/test_set/cats'
origin_test_dogs_dir = '/home/baojt/work/tensor/CatAndDogDatasets/test_set/test_set/dogs'

# 训练数据目录
train_dir = os.path.join(base_dir, 'train')
# os.mkdir(train_dir)
train_dogs_dir = os.path.join(train_dir, 'dogs')
# os.mkdir(train_dogs_dir)
train_cats_dir = os.path.join(train_dir, 'cats')
# os.mkdir(train_cats_dir)

# 测试数据目录
test_dir = os.path.join(base_dir, 'test')
# os.mkdir(test_dir)
test_cats_dir = os.path.join(test_dir, 'cats')
# os.mkdir(test_cats_dir)
test_dogs_dir = os.path.join(test_dir, 'dogs')
# os.mkdir(test_dogs_dir)

# 验证数据目录
validation_dir = os.path.join(base_dir, 'validation')
# os.mkdir(validation_dir)
validation_cats_dir = os.path.join(validation_dir, 'cats')
# os.mkdir(validation_cats_dir)
validation_dogs_dir = os.path.join(validation_dir, 'dogs')
# os.mkdir(validation_dogs_dir)

fnames = ['cat.{}.jpg'.format(i) for i in range(1000, 3500)]
for fname in fnames:
    src = os.path.join(origin_cats_dir, fname)
    dst = os.path.join(train_cats_dir, fname)
    shutil.copyfile(src, dst)
fnames = ['cat.{}.jpg'.format(i) for i in range(3501, 4000)]
for fname in fnames:
    src = os.path.join(origin_cats_dir, fname)
    dst = os.path.join(validation_cats_dir, fname)
    shutil.copyfile(src, dst)
fnames = ['cat.{}.jpg'.format(i) for i in range(4001, 5000)]
for fname in fnames:
    src = os.path.join(origin_test_cats_dir, fname)
    dst = os.path.join(test_cats_dir, fname)
    shutil.copyfile(src, dst)
fnames = ['dog.{}.jpg'.format(i) for i in range(1000, 3500)]
for fname in fnames:
    src = os.path.join(origin_dogs_dir, fname)
    dst = os.path.join(train_dogs_dir, fname)
    shutil.copyfile(src, dst)
fnames = ['dog.{}.jpg'.format(i) for i in range(3501, 4000)]
for fname in fnames:
    src = os.path.join(origin_dogs_dir, fname)
    dst = os.path.join(validation_dogs_dir, fname)
    shutil.copyfile(src, dst)
fnames = ['dog.{}.jpg'.format(i) for i in range(4001, 5000)]
for fname in fnames:
    src = os.path.join(origin_test_dogs_dir, fname)
    dst = os.path.join(test_dogs_dir, fname)
    shutil.copyfile(src, dst)


# In[13]:


print('total training cat images:', len(os.listdir(train_cats_dir)),
      '\ntotal training dog images:', len(os.listdir(train_dogs_dir)),
      '\ntotal validation cat images:', len(os.listdir(validation_cats_dir)),
      '\ntotal validation dog images:', len(os.listdir(validation_dogs_dir)),
      '\ntotal test cat images:', len(os.listdir(test_cats_dir)),
      '\ntotal test dog images:', len(os.listdir(test_dogs_dir))
      )


# In[21]:


# In[25]:


img = Image.open(os.path.join(train_cats_dir, os.listdir(train_cats_dir)[0]))

plt.figure("train_cats[0]")  # 图像窗口名称
plt.imshow(img)
plt.axis('on')  # 关掉坐标轴为 off
plt.title('image')  # 图像题目
plt.show()


# In[56]:


# 定义神经网络
model = models.Sequential()
model.add(layers.Conv2D(32, (3, 3), activation='relu', input_shape=(150, 150, 3)))
model.add(layers.MaxPooling2D((2, 2)))
model.add(layers.Conv2D(64, (3, 3), activation='relu'))
model.add(layers.MaxPooling2D((2, 2)))
model.add(layers.Conv2D(128, (3, 3), activation='relu'))
model.add(layers.MaxPooling2D((2, 2)))
model.add(layers.Conv2D(128, (3, 3), activation='relu'))
model.add(layers.MaxPooling2D((2, 2)))
model.add(layers.Flatten())
model.add(layers.Dropout(0.5))
model.add(layers.Dense(512, activation='relu'))
model.add(layers.Dense(1, activation='sigmoid'))

model.compile(loss='binary_crossentropy',
              optimizer=optimizers.RMSprop(learning_rate=1e-4),
              metrics=['acc'])
model.summary()


# In[55]:


# 图像预处理
# (1) 读取图像文件。
# (2) 将 JPEG 文件解码为 RGB 像素网格。
# (3) 将这些像素网格转换为浮点数张量。
# (4) 将像素值（0~255 范围内）缩放到 [0, 1] 区间（正如你所知，神经网络喜欢处理较小的输入值）。
# 使用keras自带的函数完成上述操作，也可以用python完成
# train_datagen = ImageDataGenerator(rescale=1./255)
# 训练数据增强
train_datagen = ImageDataGenerator(
    rescale=1./255,
    rotation_range=40,
    width_shift_range=0.2,
    height_shift_range=0.2,
    shear_range=0.2,
    zoom_range=0.2,
    horizontal_flip=True,)


test_datagen = ImageDataGenerator(rescale=1./255)

train_generator = train_datagen.flow_from_directory(
    train_dir,
    target_size=(150, 150),
    batch_size=16,
    class_mode='binary')

validation_generator = test_datagen.flow_from_directory(
    validation_dir,
    target_size=(150, 150),
    batch_size=32,
    class_mode='binary')


# In[59]:
print("TensorFlow的CPU线程数:", tf.config.threading.get_inter_op_parallelism_threads())

history = model.fit(
    x=train_generator,
    steps_per_epoch=100,
    epochs=30,
    validation_data=validation_generator,
    validation_steps=50)


# In[60]:


acc = history.history['acc']
val_acc = history.history['val_acc']
loss = history.history['loss']
val_loss = history.history['val_loss']
epochs = range(1, len(acc) + 1)
plt.plot(epochs, acc, 'bo', label='Training acc')
plt.plot(epochs, val_acc, 'b', label='Validation acc')
plt.title('Training and validation accuracy')
plt.legend()
plt.figure()
plt.plot(epochs, loss, 'bo', label='Training loss')
plt.plot(epochs, val_loss, 'b', label='Validation loss')
plt.title('Training and validation loss')
plt.legend()
plt.show()


# In[61]:


model.save('cats_and_dogs_small_2.h5')


# In[ ]:
