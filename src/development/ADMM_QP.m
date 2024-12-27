function x = ADMM_QP(A1,A2,b1,b2, q, P)
    % Import necessary utility functions
    [A,l,u] = standard_constraints(A2,-b2,A1,-b1);
    sigma = 1e-6;
    alpha = 1.6;
    n = size(P, 1);
    m = size(A, 1);
    x = zeros(n,1);
    y = zeros(m,1);
    z = zeros(m,1);
    rho = 0.1;
    prim_tol = 1e-4;
    dual_tol = 1e-6;
    max_iter = 2;
    function rho_estimate = compute_rho()
        RHO_MIN = 1e-06;
        RHO_MAX=1e06;
        DIVISION_TOL = 1e-20;
        prim_res_norm = norm(z,1);
        temp_res_norm = norm(A*x,1); 
        prim_res_norm = max(prim_res_norm, temp_res_norm);
        prim_res = prim_res/(prim_res_norm + DIVISION_TOL);
        
        dual_res_norm = norm(q,1);
        temp_res_norm = norm(A'*y,1);
        dual_res_norm = max(dual_res_norm, temp_res_norm);
        temp_res_norm = norm(P*x,1);
        dual_res_norm = max(dual_res_norm, temp_res_norm);
        dual_res = dual_res/(dual_res_norm + DIVISION_TOL);
    
        rho_estimate = norm(rho * sqrt(prim_res / dual_res),1);
        rho_estimate = min(max(rho_estimate, RHO_MIN), RHO_MAX);
    end
    for i = 1: max_iter
        x_prev = x;
        for j = 1:200
            M = P + sigma * eye(n) + rho * (A'* A);
            b =  sigma* x - q + A'*(rho*z - y );
            x_tilde = conjgrad(M,b);
            z_tidle = A*x_tilde;
            x_next = alpha * x_tilde + (1 - alpha) * x;
            z_next = Pc(alpha * z_tidle + (1 - alpha) * z + 1 / rho * y, l, u);
            y = y + rho * (alpha * z_tidle + (1 - alpha) * z - z_next);
            z = z_next;
            prim_res = A*x-z;
            dual_res = P * x_next + q + A' * y;
    
            if norm(prim_res) <= prim_tol && norm(dual_res) <= dual_tol
                x = x_next;
                break;
            end
            
            x = x_next;
        end
        if norm(x - x_prev)<1e-6
            break;
        end
        rho = compute_rho();
    end
end