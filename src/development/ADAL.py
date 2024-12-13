import numpy as np
from typing import Tuple

def standard_constraints(G, h, A, b)-> Tuple[np.ndarray[np.float64], np.ndarray[np.float64], np.ndarray[np.float64]]:
    """
    Convert constraints Gx <= h and Ax = b into a unified form l <= Ax <= u.

    Parameters:
        G (ndarray): Coefficient matrix for inequality constraints.
        h (ndarray): Upper bound for inequality constraints.
        A (ndarray): Coefficient matrix for equality constraints.
        b (ndarray): Right-hand side for equality constraints.

    Returns:
        A_osqp (csr_matrix): Combined constraint matrix.
        l_osqp (ndarray): Lower bounds.
        u_osqp (ndarray): Upper bounds.
    """
    A_osqp = None
    l_osqp = None
    u_osqp = None
    if G is not None and h is not None:
        A_osqp = G
        l_osqp = np.full(h.shape, -np.inf)
        u_osqp = h
    if A is not None and b is not None:
        A_osqp = A if A_osqp is None else np.vstack([A_osqp, A])
        l_osqp = b if l_osqp is None else np.hstack([l_osqp, b])
        u_osqp = b if u_osqp is None else np.hstack([u_osqp, b])

    return A_osqp,l_osqp,u_osqp




def ADAL(A1:np.ndarray, A2:np.ndarray ,b1:np.ndarray ,b2: np.ndarray,q:np.ndarray,P:np.ndarray,x0, y0, z0, eta, rho, alpha):
    x = x0
    y = y0
    z = z0
    A_osqp,l_osqp,u_osqp = standard_constraints(A2,-b2,A1,-b1)
    def Pc(z):
        for i in range(len(z)):
            if l_osqp[i] <= z[i] and z[i] <= u_osqp[i]:
                pass
            else:
                z[i] = u_osqp[i]
        return z
    def solve_linear_sys():
        M = np.vstack([np.block([P+eta*np.eye(P.shape[0]),A_osqp.T]),np.block([A_osqp,-1/rho*np.eye(A_osqp.shape[0])])])
        b = np.hstack([eta*x-q,z-1/rho*y])
        xv = np.linalg.solve(M, b)
        x_hat,v = np.split(xv,[P.shape[0]])
        return x_hat,v
    
    while(True):
        x_hat,v = solve_linear_sys()
        z_hat = z+1/rho*(v-y)
        x_next = alpha*x_hat + (1-alpha)*x
        z_next = Pc(alpha*z_hat + (1-alpha)*z+1/rho*y)
        y = y+rho*(alpha*z_hat+ (1-alpha)*z-z_next)
        z = z_next
        r = np.linalg.norm(x-x_next)
        x = x_next
        if r<1e-8:
            return x