
function [A_osqp, l_osqp, u_osqp] = standard_constraints(G, h, A, b)
    % Convert constraints Gx <= h and Ax = b into a unified form l <= Ax <= u.
    % 
    % Parameters:
    %     G: Coefficient matrix for inequality constraints.
    %     h: Upper bound for inequality constraints.
    %     A: Coefficient matrix for equality constraints.
    %     b: Right-hand side for equality constraints.
    % 
    % Returns:
    %     A_osqp: Combined constraint matrix.
    %     l_osqp: Lower bounds.
    %     u_osqp: Upper bounds.

    A_osqp = [];
    l_osqp = [];
    u_osqp = [];

    if ~isempty(G) && ~isempty(h)
        A_osqp = G;
        l_osqp = -inf(size(h));
        u_osqp = h;
    end
    if ~isempty(A) && ~isempty(b)
        if isempty(A_osqp)
            A_osqp = A;
            l_osqp = b;
            u_osqp = b;
        else
            A_osqp = [A_osqp; A];
            l_osqp = [l_osqp; b];
            u_osqp = [u_osqp; b];
        end
    end
end



