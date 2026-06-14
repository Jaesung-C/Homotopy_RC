function dxdt = eq_rossler(~, x, flag)
% EQ_ROSSLER  Rössler system ODEs.
%   dxdt = eq_rossler(~, x, flag)
%   x is the state [x1; x2; x3]; flag is the parameter vector [a, b, c].

a = flag(1);  b = flag(2);  c = flag(3);

dxdt = zeros(3, 1);
dxdt(1) = -x(2) - x(3);
dxdt(2) =  x(1) + a*x(2);
dxdt(3) =  b + x(3)*(x(1) - c);
end
