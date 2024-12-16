import numpy as np
from utils import standard_constraints

def IRWA(A1:np.ndarray, A2:np.ndarray ,b1:np.ndarray ,b2: np.ndarray,g:np.ndarray,H:np.ndarray, x0, epsilon0, eta, gamma, M, sigma = 1e-6, sigma_prime = 1e-6):
    # eq_num,n = A1.shape
    ineq_num, n = A2.shape
    A,l,u = standard_constraints(A2,-b2,A1,-b1)
    x = x0
    epsilon = epsilon0
    m, n = A.shape
    k = 0
    while(True):
        k+=1
        # Step 1: Solve the reweighted subproblem
        W = np.diag([(((max(0, A[i] @ x - u[i])**2 + epsilon[i]**2)**-0.5) if i < ineq_num else \
                     (np.abs(A[i] @ x - u[i])**2 + epsilon[i]**2)**-0.5) for i in range(m)])
        v = np.array([((max(-u[i], -A[i] @ x) ) if i < ineq_num else -u[i]) for i in range(m)]).T
        H_tilde = H + A.T @ W @ A
        g_tilde = g+A.T @ W @ v
        x_next = np.linalg.solve(H_tilde, -g_tilde)
        # Step 2: Update relaxation vector
        q = A @ (x_next - x)
        r = [(1 - v[i]) * (A[i] @ x + u[i]) for i in range(m)]
        if all(np.abs(q[i]) <= M * (r[i]**2 + epsilon[i]**2)**(0.5 + gamma) for i in range(m)):
            epsilon = epsilon * eta
            if epsilon.all() == 0: epsilon =epsilon+1e-150
        # Step 3: Check stopping criteria
        if np.linalg.norm(x_next - x, 2) <= sigma and np.linalg.norm(epsilon, 2) <= sigma_prime:
            x = x_next
            break
        if k>30000:
            break
        x = x_next
    return x



