function defaults = eq_mackeyDefaults()
% EQ_MACKEYDEFAULTS  Default parameters struct for the Mackey-Glass DDE.
%   tau=17, beta=0.2, gamma=0.1, n=10 places the system in the chaotic regime.

defaults.parms    = [0.2, 0.1, 10];
defaults.delay    = 17;                 % tau (chaotic for tau>16.8)
defaults.x0       = 1.2;
defaults.datLen   = 21000;
defaults.initTime = 10;                % history interval [−initTime, 0]
defaults.stepSize = 1;
defaults.solver   = 'dde23_solver';
defaults.history  = @(t) 1.2;
end
