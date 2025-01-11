function x = IRWA(A1, A2, b1, b2, g, H, x0, epsilon0, eta, gamma, M, prim_tol, dual_tol, max_iter)
    A = [A1;A2];
    b = [b1;b2];
    x = x0;
    epsilon = epsilon0;


    for k = 1:max_iter
        Eq = A1*x;
        Ineq = A2*x;
        w = [Eq+b1;(max(Ineq,-b2)+b2)];
        w = (epsilon.^2+w.^2).^(-0.5);
        W = diag(w);
        v = [b1;max(-Ineq,b2)];
        H_tilde = H + A' * W * A;
        g_tilde = g + A' * W * v;
        x_next = lsqminnorm(H_tilde,-g_tilde);

        % Step 2: Update relaxation vector
        q = A * (x_next - x);
        r = (1-v).*(A*x+b);
        if all(abs(q) <= M * ((r.^2 + epsilon.^2).^(0.5 + gamma)))
            epsilon = epsilon * eta;
        end
        % Step 3: Check stopping criteria
        if norm(x_next - x,inf) <= prim_tol && norm(epsilon,inf) <= dual_tol
            x = x_next;
            break;
        end
        x = x_next;
    end
end
