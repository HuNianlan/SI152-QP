function x = IRWA(A1, A2, b1, b2, g, H, x0, epsilon0, eta, gamma, M, sigma, sigma_prime)
    if nargin < 12
        sigma = 1e-5;
        sigma_prime = 1e-8;
    end
    A = [A1;A2];
    b = [b1;b2];
    x = x0;
    epsilon = epsilon0;
    k = 0;
    
    while true
        k = k + 1;
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
        if norm(x_next - x) <= sigma && norm(epsilon, 2) <= sigma_prime
            x = x_next;
            break;
        end

        if k > 500
            break;
        end

        x = x_next;
    end
end