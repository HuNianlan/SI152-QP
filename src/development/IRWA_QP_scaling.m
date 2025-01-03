function x = IRWA_QP_scaling(A1, A2, b1, b2, g, H)
    A = [A1; A2];
    b = [b1; b2];

    n = size(g, 1);
    m_eq = size(A1, 1);
    m_ineq = size(A2, 1);
    m = size(A, 1);
    epsilon = ones(m, 1);
    x = zeros(n, 1);
    gamma = 0;
    if n<=200
        eta = 0.99;
        M = 10;
    elseif n<1000
        eta = 0.9;
        M = 20;
    else 
        eta = 0.9;
        M = 100;
    end
    prim_tol = 1e-6;
    dual_tol = 1e-6;
    max_iter = 4000;

    scale_eq = 1 / norm(A1, 'fro');
    scale_ineq = 1 / norm(A2, 'fro');  
    scaling_matrix = diag([scale_eq * ones(m_eq, 1); scale_ineq * ones(m_ineq, 1)]);

    A_scaled = scaling_matrix * A;
    b_scaled = scaling_matrix * b;

    for k = 1:max_iter
        Eq = A1 * x;
        Ineq = A2 * x;
        w = [Eq + b1; (max(Ineq, -b2) + b2)];

        w_scaled = scaling_matrix * w;
        % w_scaled =(epsilon.^2 + w_scaled.^2).^(-0.5) + 1 ./ epsilon;
        w_scaled =max((epsilon.^2 + w_scaled.^2).^(-0.5) ,1 ./ epsilon);
        W = diag(w_scaled);

        v = scaling_matrix * [b1; max(-Ineq, b2)];

        H_tilde = H + A_scaled' * W * A_scaled;
        g_tilde = g + A_scaled' * W * v;
        x_next = lsqminnorm(H_tilde, -g_tilde);
        % x_next = conjgrad(H_tilde, -g_tilde,1e-4);

        % Step 2: Update relaxation vector
        q = A_scaled * (x_next - x);
        r = scaling_matrix * ((1 - v) .* (A_scaled * x + b_scaled));

        if all(abs(q) <= M * ((r.^2 + epsilon.^2).^(0.5 + gamma)))
            epsilon = epsilon * eta;
        end
        primal =norm(x_next - x,inf);
        er =norm(epsilon,inf);
        % Step 3: Check stopping criteria
        if primal <= prim_tol && er <= dual_tol
            x = x_next;
            break;
        end
        % x'*H*x/2+g'*x
        x = x_next;
    end
end
