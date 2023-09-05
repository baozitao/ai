import numpy as np
from scipy.optimize import fsolve
import matplotlib.pyplot as plt

# 定义函数
def f(x):
    return 3*x + 6 - x**2

# 使用fsolve函数求解交点
x_cross = fsolve(f, [-10, 10])
y_cross = [3*x + 6 for x in x_cross]
cross_points = list(zip(x_cross, y_cross))

# 生成x的值
x = np.linspace(-10, 10, 400)

# 生成y的值
y1 = 3*x + 6
y2 = x**2

# 创建一个新的图形
plt.figure()

# 画出函数
plt.plot(x, y1, label='y=3x+6')
plt.plot(x, y2, label='y=x^2')

# 画出交点
for point in cross_points:
    plt.plot(*point, 'ro') # 'ro' means red dots
    plt.text(point[0], point[1], f'({point[0]:.2f}, {point[1]:.2f})')

# 显示网格线
plt.grid(True)

# 显示图例
plt.legend()

# 显示图形
plt.show()