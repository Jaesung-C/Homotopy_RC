function defaults = eq_lorenzDefaults()
% EQ_LORENZDEFAULTS  Default settings struct for the Lorenz system.

defaults.description = 'Lorenz chaotic attractor';
defaults.parms       = [10, 28, 8/3];
defaults.x0          = [1, 1, 1];
defaults.datLen      = 21000;
defaults.initTime    = 10;
defaults.stepSize    = 0.01;
defaults.smplRatio   = 1;
defaults.reference   = 'Lorenz 1963';
defaults.solver      = 'rk4_solver';
end
