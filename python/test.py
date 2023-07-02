#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 29 00:37:20 2023

@author: baojt
"""
import torch
import torch.nn as nn

# 创建一个简单的全连接神经网络模型


class MyModel(nn.Module):
    def __init__(self):
        super(MyModel, self).__init__()
        self.fc1 = nn.Linear(10, 20)  # 创建一个大小为10x20的全连接层
        self.fc2 = nn.Linear(20, 2)   # 创建一个大小为20x2的全连接层

    def forward(self, x):
        x = self.fc1(x)  # 将输入数据传递到第一层全连接层
        x = nn.functional.relu(x)  # 对第一层的输出进行ReLU激活函数处理
        x = self.fc2(x)  # 将第一层的输出传递到第二层全连接层
        return x  # 返回第二层的输出


# 创建一个模型实例
model = MyModel()

# 定义输入数据
x = torch.randn(1, 10)

# 使用模型进行预测
y = model(x)

# 打印输出的y值
print(y)
