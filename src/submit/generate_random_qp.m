function [H, g, A1, A2, b1, b2] = generate_random_qp(n, m1, m2)
    % Generates a random QP problem:
    % min (1/2)*x'Hx + g'x
    % s.t. A1*x + b1 = 0
    %      A2*x + b2 <= 0
    %
    % Inputs:
    %   n - Dimension of variable x
    %   m1 - Number of equality constraints
    %   m2 - Number of inequality constraints
    %
    % Outputs:
    %   H  - Positive definite matrix (n x n)
    %   g  - Gradient vector (n x 1)
    %   A1 - Equality constraint matrix (m1 x n)
    %   b1 - Equality constraint vector (m1 x 1)
    %   A2 - Inequality constraint matrix (m2 x n)
    %   b2 - Inequality constraint vector (m2 x 1)

    % Generate a random symmetric positive definite matrix H
    R = randn(n, n); % Random matrix
    H = R' * R + eye(n); % Ensure positive definiteness by adding eye(n)

    % Generate a random gradient vector g
    g = randn(n, 1);

    % Generate random equality constraint matrix A1 and vector b1
    A1 = randn(m1, n);
    b1 = randn(m1, 1);

    % Generate random inequality constraint matrix A2 and vector b2
    A2 = randn(m2, n);
    b2 = randn(m2, 1);

end