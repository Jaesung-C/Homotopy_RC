function rnew = homotopy_rc(r_prev, input, args_rc)
% HOMOTOPY_RC  One-step update of the Lorenz-based Homotopy Reservoir.
%
% Blends each coupled Lorenz node between its chaotic attractor dynamics and
% a stable fixed point, weighted by input magnitude and distance from
% equilibrium. States are stored as deviation from equ_vector.

struct2vars(args_rc);

r_prev = r_prev + equ_vector;

x = r_prev(1:3:(3*N-2));
y = r_prev(2:3:(3*N-1));
z = r_prev(3:3:3*N);

rnew = zeros(3*N, 1);

u = Win * input;

rng('default')

for i = 1:N
    ext = [u(3*(i-1)+1); u(3*(i-1)+2); u(3*(i-1)+3)];

    s1 = (1 - exp(-p1 * norm(ext))) * ...
          exp(-p2 * norm([x(i)-equix, y(i)-equiy, z(i)-equiz]));
    s2 = 1 - s1;

    n_conn = sum(A(i,:)) + 1;
    cx = ep * (A(i,:) * (x - x(i))) / n_conn;
    cy = ep * (A(i,:) * (y - y(i))) / n_conn;
    cz = ep * (A(i,:) * (z - z(i))) / n_conn;

    rate = 1 + var_l1 * randn(1);

    rnew(3*(i-1)+1) = x(i) + rate * ( ...
        h*s1*(sig*(y(i)-x(i)) + cx) + ...
        h*s2*(equix - x(i))         + ...
        h*ext(1) );

    rnew(3*(i-1)+2) = y(i) + rate * ( ...
        h*s1*(x(i)*(rho + var_l2*randn(1) - z(i)) - y(i) + cy) + ...
        h*s2*(equiy - y(i))                                      + ...
        h*ext(2) );

    rnew(3*(i-1)+3) = z(i) + rate * ( ...
        h*s1*(x(i)*y(i) - be*z(i) + cz) + ...
        h*s2*(equiz - z(i))               + ...
        h*ext(3) );
end

rnew = rnew - equ_vector;
end
