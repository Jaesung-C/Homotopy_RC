function [t, data] = dde23_solver(eq_sys, ~, defaults)
% DDE23_SOLVER  Solve a delay differential equation using MATLAB's dde23.
%   [t, data] = dde23_solver(eq_sys, x0, defaults)
%   eq_sys names the RHS function with signature dxdt = f(t, x, Z, parms).
%   x0 is ignored (interface consistency with rk4_solver); the initial state
%   comes from defaults.history.

dt      = defaults.stepSize;
odefun  = str2func(eq_sys);
tspan   = [-defaults.initTime, dt * defaults.datLen];

sol = dde23(@(t, x, Z) odefun(t, x, Z, defaults.parms), ...
            defaults.delay, defaults.history, tspan);

t    = 0 : dt : dt * defaults.datLen;
data = deval(sol, t);
end
