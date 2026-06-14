function [t, data] = rk4_solver(eq_sys, x0, defaults)
% RK4_SOLVER  4th-order Runge-Kutta solver for autonomous ODEs.
%   [t, data] = rk4_solver(eq_sys, x0, defaults)
%   Integrates eq_sys from x0, discards an initTime transient, then returns
%   datLen samples at stepSize downsampled by smplRatio. eq_sys is a function
%   name or handle called as dxdt = eq_sys(t, x, parm).

dt     = defaults.stepSize;
odefun = str2func(eq_sys);

tInit  = -defaults.initTime : dt : -dt;
nInit  = length(tInit);
xInit  = zeros(length(x0), nInit);
xInit(:,1) = x0(:);

for i = 1:nInit-1
    k1 = odefun(tInit(i),         xInit(:,i),           defaults.parm);
    k2 = odefun(tInit(i)+0.5*dt,  xInit(:,i)+0.5*dt*k1, defaults.parm);
    k3 = odefun(tInit(i)+0.5*dt,  xInit(:,i)+0.5*dt*k2, defaults.parm);
    k4 = odefun(tInit(i)+dt,      xInit(:,i)+dt*k3,      defaults.parm);
    xInit(:,i+1) = xInit(:,i) + (dt/6)*(k1 + 2*k2 + 2*k3 + k4);
end

x0_main = xInit(:,end);

nMain  = defaults.datLen * defaults.smplRatio + 1;
t_full = (0:nMain-1) * dt;
data_full = zeros(length(x0), nMain);
data_full(:,1) = x0_main;

for i = 1:nMain-1
    k1 = odefun(t_full(i),         data_full(:,i),           defaults.parm);
    k2 = odefun(t_full(i)+0.5*dt,  data_full(:,i)+0.5*dt*k1, defaults.parm);
    k3 = odefun(t_full(i)+0.5*dt,  data_full(:,i)+0.5*dt*k2, defaults.parm);
    k4 = odefun(t_full(i)+dt,      data_full(:,i)+dt*k3,      defaults.parm);
    data_full(:,i+1) = data_full(:,i) + (dt/6)*(k1 + 2*k2 + 2*k3 + k4);
end

t    = t_full(1:defaults.smplRatio:end);
data = data_full(:, 1:defaults.smplRatio:end);
end
