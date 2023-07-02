#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 29 01:25:33 2023

@author: baojt
"""
import torch

# 创建一个2*2的张量
x = torch.randn(2, 2)

# 获取张量中元素的数量
num_elements = x.numel()

print(num_elements)
print(x)