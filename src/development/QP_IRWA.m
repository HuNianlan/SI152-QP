function x = QP_IRWA(A1, A2, b1, b2, g, H)
    A = [A1;A2];
    b = [b1;b2];

    n = size(g,1);
    m = size(A,1);
    epsilon = 0.1*ones(m,1);
    x = zeros(n,1);
    eta = 0.9;
    gamma = 0.7;
    M = 100;
    prim_tol = 1e-6;
    dual_tol = 1e-12;
    max_iter = 4000;

    for k = 1:max_iter
        Eq = A1*x;
        Ineq = A2*x;
        w = [Eq+b1;(max(Ineq,-b2)+b2)];
        w = (epsilon.^2+w.^2).^(-0.5)+1./epsilon;
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
        if norm(x_next - x) <= prim_tol && norm(epsilon) <= dual_tol
            x = x_next;
            break;
        end
        x = x_next;
    end
end
