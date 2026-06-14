function dxdt = eq_mackey(~, x, Z, flag)
% EQ_MACKEY  Mackey-Glass delay differential equation.
%   dx/dt = beta * x(t-tau) / (1 + x(t-tau)^n) - gamma * x(t)
%   Called by dde23_solver. Z is the delayed state x(t-tau);
%   flag is the parameter vector [beta, gamma, n].

beta  = flag(1);
gamma = flag(2);
n     = flag(3);

dxdt = beta * Z / (1 + Z^n) - gamma * x;
end
