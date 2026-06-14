function rnew = homotopy_rc_KS(r_prev, input, args_rc)
% HOMOTOPY_RC_KS  One-step update of the Kuramoto-Sivashinsky (KS) reservoir.
%
% Uses the KS PDE  u_t + u*u_x + u_xx + u_xxxx = 0, integrated spectrally via
% ETDRK4, blended per spatial node toward the KS equilibrium (u = 0). States
% are stored as deviation from equ_vector.

struct2vars(args_rc);

r_prev = r_prev + equ_vector;

u = Win * input;

rng('default');

r_ks_next = ks_step(r_prev, args_rc);

rnew = zeros(N, 1);
for i = 1:N
    ext = u(i);

    s1 = (1 - exp(-p1 * abs(ext))) * exp(-p2 * abs(r_prev(i) - equ_vector(i)));
    s2 = 1 - s1;

    rate = 1 + var_l1*randn(1);

    ks_delta = r_ks_next(i) - r_prev(i);
    eq_pull  = equ_vector(i) - r_prev(i);

    rnew(i) = r_prev(i) + rate * ( ...
        s1*ks_delta + s2*h*eq_pull + h*ext );
end

rnew = rnew - equ_vector;
end
