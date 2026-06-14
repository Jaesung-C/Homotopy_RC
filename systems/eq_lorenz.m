function dxdt = eq_lorenz(~, x, flag)
% EQ_LORENZ  Lorenz system ODEs.
%   dxdt = eq_lorenz(~, x, flag)
%   x is the state [x1; x2; x3]; flag is the parameter vector [sigma, rho, beta].
%   Also serves as the individual reservoir node dynamics in homotopy_rc.

sigma = flag(1);  rho = flag(2);  beta = flag(3);

dxdt = zeros(3, 1);
dxdt(1) = sigma*(x(2) - x(1));
dxdt(2) = x(1)*(rho - x(3)) - x(2);
dxdt(3) = x(1)*x(2) - beta*x(3);
end
