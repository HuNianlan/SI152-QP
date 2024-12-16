from typing import Tuple
import numpy as np

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



def Pc(z,l,u):
    # Projection onto the set C={x|l <= x <=u}
    for i in range(len(z)):
        if l[i] <= z[i] and z[i] <= u[i]:
            pass
        else:
            z[i] = u[i]
    return z