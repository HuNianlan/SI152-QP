import numpy as np
import matplotlib.pyplot as plt
from qpsolvers import solve_qp
import matlab.engine

# 启动 MATLAB 引擎
eng = matlab.engine.start_matlab()

# 设置工作目录
eng.cd('D:/24Fall/Numerical Optimization/Final_Project/SI152-QP/src/Plot', nargout=0)

# 设置问题参数
n_problems = 500  # 总问题数量
tolerance = 50    # 误差阈值
max_iter = 500    # 最大迭代次数

# 初始化记录
num_iterations = np.zeros(max_iter + 1)  # 每个迭代次数的成功次数
success_iterations = 0                   # 成功解决问题的数量

for _ in range(n_problems):
    # 生成随机 QP 参数
    n, m1, m2 = 500, 100, 100
    H, g, A1, A2, b1, b2 = eng.generate_random_qp(n, m1, m2, nargout=6)

    # 转为 numpy 格式
    H_np = np.array(H)
    g_np = np.array(g)
    A1_np = np.array(A1)
    b1_np = np.array(b1)
    A2_np = np.array(A2)
    b2_np = np.array(b2)

    # 使用 MATLAB 的 IRWA_QP_scaling
    y, num_iter = eng.ADMM_QP(A1_np, A2_np, -b1_np, -b2_np, g_np, H_np, nargout=2)
    num_iter = int(num_iter)  # 确保 num_iter 为整数

    # 使用 Python 库计算最优解
    optimal_y = solve_qp(H_np, g_np, A2_np, b2_np, A1_np, b1_np, solver="cvxopt")

    # 转为 numpy 格式
    y_np = np.array(y).flatten()
    optimal_y_np = np.array(optimal_y).flatten()

    # 计算误差
    # print(y_np, optimal_y_np)
    error = np.linalg.norm(y_np - optimal_y_np)
    print(error)
    if error < tolerance:
        success_iterations += 1
        if num_iter <= max_iter:
            num_iterations[num_iter] += 1

# 关闭 MATLAB 引擎
eng.quit()

# 计算累计比例
cumulative_solved = np.cumsum(num_iterations) / n_problems

# 绘制比例图
plt.figure(figsize=(10, 6))
plt.plot(range(max_iter + 1), cumulative_solved, label="Proportion Solved")
plt.xlabel("Loop Count")
plt.ylabel("Proportion of Problems Solved")
plt.title("Proportion of QPs Solved Over Iterations")
plt.grid(True)
plt.legend()
plt.savefig("ADMMQP_percentage_solved.png")
plt.show()
