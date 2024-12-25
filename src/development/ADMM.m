function x = ADMM(A_osqp, l_osqp,u_osqp,q,P,x0, y0, z0, rho, tol)
    x = x0;
    z = z0;
    y = y0;

    for k = 1:1000

        KKT_matrix = P + rho * (A_osqp' * A_osqp);
        rhs = -q + A_osqp' * (rho * z - y);
        x = KKT_matrix \ rhs;

        z = Pc(A_osqp * x + y / rho, l_osqp, u_osqp);

        y = y + rho * (A_osqp * x - z);

        primal_residual = norm(A_osqp * x - z);
        dual_residual = rho * norm(A_osqp' * (z - A_osqp * x));

        if primal_residual < tol && dual_residual < tol
            break;
        end
    end
end