function x = ADMM(A,l,u, q, P, x0, y0, z0,rho,prim_tol,dual_tol,max_iter)
    % Import necessary utility functions
    sigma = 1e-6;
    alpha = 1.6;
    x = x0;
    y = y0;
    z = z0;
    n = size(P, 1);
    m = size(A, 1);
    function [x_tilde, v] = solve_linear_sys()
        M = [P + sigma * eye(n), A';
            A, -1 / rho * eye(m)];
        b = [sigma * x - q; z - 1 / rho * y];
        xv = lsqminnorm(M,b);
        % xv = M \ b;  % Solve the linear system
        x_tilde = xv(1:n);
        v = xv(n + 1:end);
    end

    for i = 1: max_iter
        [x_tilde, v] = solve_linear_sys();
        z_hat = z + 1 / rho * (v - y);
        x_next = alpha * x_tilde + (1 - alpha) * x;
        z_next = Pc(alpha * z_hat + (1 - alpha) * z + 1 / rho * y, l, u);
        y = y + rho * (alpha * z_hat + (1 - alpha) * z - z_next);
        z = z_next;
        r = P * x_next + q + A' * y;

        if norm(x_next - x) <= prim_tol && norm(r) <= dual_tol
            x = x_next;
            break;
        end

        x = x_next;
    end
end
