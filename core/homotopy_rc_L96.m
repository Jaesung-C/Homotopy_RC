function rnew = homotopy_rc_L96(r_prev, input, args_rc)
% HOMOTOPY_RC_L96  One-step update of the Lorenz-96 reservoir.
%
% Uses the Lorenz-96 model  dx_i/dt = (x_{i+1}-x_{i-2})*x_{i-1} - x_i + F
% (cyclic i), blended per variable toward the L96 equilibrium x_i = F.
% States are stored as deviation from equ_vector.

struct2vars(args_rc);

r_prev = r_prev + equ_vector;

u = Win * input;

rng('default');

rnew = zeros(N, 1);
for i = 1:N
    ip1 = mod(i,   N) + 1;
    im1 = mod(i+N-2, N) + 1;
    im2 = mod(i+N-3, N) + 1;

    ext = u(i);

    s1 = (1 - exp(-p1 * abs(ext))) * exp(-p2 * abs(r_prev(i) - equ_vector(i)));
    s2 = 1 - s1;

    rate = 1 + var_l1*randn(1);

    L96_term = (r_prev(ip1) - r_prev(im2))*r_prev(im1) ...
               - r_prev(i) + F + var_l2*randn(1);

    rnew(i) = r_prev(i) + rate * ( ...
        h*s1*L96_term              + ...
        h*s2*(equ_vector(i) - r_prev(i)) + ...
        h*ext );
end

rnew = rnew - equ_vector;
end
