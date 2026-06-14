function defaults = eq_rosslerDefaults()
% EQ_ROSSLERDEFAULTS  Default settings struct for the Rössler system.
%   Used by defaults2args to fill in any unspecified fields of args_data.

defaults.description = 'Rössler chaotic attractor';
defaults.parms       = [0.2, 0.2, 5.7];
defaults.x0          = [0, 1, 1];
defaults.datLen      = 21000;
defaults.initTime    = 1;
defaults.stepSize    = 0.01;
defaults.smplRatio   = 10;
defaults.reference   = 'Rössler 1976';
defaults.solver      = 'rk4_solver';
end
