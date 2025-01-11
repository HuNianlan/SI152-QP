import numpy as np
import matplotlib.pyplot as plt
from qpsolvers import solve_qp
import matlab.engine

# 启动 MATLAB 引擎
eng = matlab.engine.start_matlab()

# 设置工作目录
eng.cd('D:/24Fall/Numerical Optimization/Final_Project/SI152-QP/src/Plot', nargout=0)

# 设置最大迭代次数
max_iter = 500

# 随机生成问题数据
n, m1, m2 = 500, 100, 100
H, g, A1, A2, b1, b2 = eng.generate_random_qp(n, m1, m2, nargout=6)

# 转为 numpy 格式
H_np = np.array(H)
g_np = np.array(g)
A1_np = np.array(A1)
b1_np = np.array(b1)
A2_np = np.array(A2)
b2_np = np.array(b2)

# 使用 MATLAB 的 IRWA_QP_scaling 方法计算 residual
_, num_iter_1, residual_1 = eng.IRWA_QP_scaling(A1_np, A2_np, -b1_np, -b2_np, g_np, H_np, nargout=3)
_, num_iter_2, residual_2 = eng.ADMM_QP(A1_np, A2_np, -b1_np, -b2_np, g_np, H_np, nargout=3)

# 转为 numpy 格式
residual_1_np = np.array(residual_1).flatten()
residual_2_np = np.array(residual_2).flatten()

# 确保 residual 的长度为 max_iter
residual_1_padded = np.zeros(max_iter)
residual_2_padded = np.zeros(max_iter)

# 将原始 residual 填充到新数组中
residual_1_padded[:len(residual_1_np)] = residual_1_np
residual_2_padded[:len(residual_2_np)] = residual_2_np

# 创建横坐标
x = np.arange(max_iter)

# 绘图
plt.figure(figsize=(10, 6))
# plt.plot(x, residual_1_padded, label="Residual 1", linewidth=2)
plt.plot(x, residual_2_padded, label="Residual 2", linewidth=2, linestyle="--")
plt.xlabel("Iteration", fontsize=14)
plt.ylabel("Residual Value", fontsize=14)
plt.title("Residuals over Iterations", fontsize=16)
plt.legend(fontsize=12)
plt.grid(True)
plt.tight_layout()

# 显示图形
plt.show()

