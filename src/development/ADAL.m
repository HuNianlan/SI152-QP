function x = ADAL(A1, A2, b1, b2, q, P, x0, y0, z0, eta, rho, alpha, sigma,sigma_prime)
    if nargin < 13
        sigma = 1e-6;
    end
    % Import necessary utility functions
    [A, l, u] = standard_constraints(A2, -b2, A1, -b1);
    x = x0;
    y = y0;
    z = z0;
    function [x_hat, v] = solve_linear_sys()
        M = [P + eta * eye(size(P, 1)), A'; 
            A, -1 / rho * eye(size(A, 1))];
        b = [eta * x - q; z - 1 / rho * y];
        xv = lsqminnorm(M,b);
        % xv = M \ b;  % Solve the linear system
        x_hat = xv(1:size(P, 1));
        v = xv(size(P, 1) + 1:end);
    end

    while true
        [x_hat, v] = solve_linear_sys();
        z_hat = z + 1 / rho * (v - y);
        x_next = alpha * x_hat + (1 - alpha) * x;
        z_next = Pc(alpha * z_hat + (1 - alpha) * z + 1 / rho * y, l, u);
        y = y + rho * (alpha * z_hat + (1 - alpha) * z - z_next);
        z = z_next;
        r = P * x_next + q + A' * y;

        if norm(x_next - x, 2) <= sigma && norm(r, 2) <= sigma_prime
            x = x_next;
            break;
        end

        x = x_next;
    end
end