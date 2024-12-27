function x = ADAL(A, l,u,q,P,x0, y0, z0, rho, prim_tol,dual_tol,max_iter)
    x = x0;
    z = z0;
    y = y0;

    for k = 1:max_iter

        KKT_matrix = P + rho * (A' * A);
        rhs = -q + A' * (rho * z - y);
        x = KKT_matrix \ rhs;

        z = Pc(A * x + y / rho, l, u);

        y = y + rho * (A * x - z);

        primal_residual = norm(A * x - z);
        dual_residual = rho * norm(A' * (z - A * x));

        if primal_residual < prim_tol && dual_residual < dual_tol
            break;
        end
    end
end
