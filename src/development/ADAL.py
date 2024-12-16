import numpy as np
from utils import standard_constraints,Pc

def ADAL(A1:np.ndarray, A2:np.ndarray ,b1:np.ndarray ,b2: np.ndarray,q:np.ndarray,P:np.ndarray,x0, y0, z0, eta, rho, alpha,sigma=1e-6):
    A,l,u = standard_constraints(A2,-b2,A1,-b1)
    x = Pc(x0,l,u)
    y = y0
    z = z0
    def solve_linear_sys():
        M = np.vstack([np.block([P+eta*np.eye(P.shape[0]),A.T]),np.block([A,-1/rho*np.eye(A.shape[0])])])
        b = np.hstack([eta*x-q,z-1/rho*y])
        xv = np.linalg.solve(M, b)
        x_hat,v = np.split(xv,[P.shape[0]])
        return x_hat,v
    
    while(True):
        x_hat,v = solve_linear_sys()
        z_hat = z+1/rho*(v-y)
        x_next = alpha*x_hat + (1-alpha)*x
        z_next = Pc(alpha*z_hat + (1-alpha)*z+1/rho*y,l,u)
        y = y+rho*(alpha*z_hat+ (1-alpha)*z-z_next)
        z = z_next
        r = P@x_next+q+A.T@y
        # r = np.linalg.norm(x-x_next)
        # x = x_next
        if np.linalg.norm(x_next - x, 2) <= sigma and np.linalg.norm(r, 2) <= sigma:
            x = x_next
            break
        x = x_next
    return x