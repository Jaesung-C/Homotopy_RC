function args_rc = homotopyDefaults_L96()
% HOMOTOPYDEFAULTS_L96  Default parameters for the Lorenz-96 HRC reservoir.
%
% Returns a parameter struct for the Lorenz-96 model with standard chaotic
% forcing (F=8, N=40). r0 is given in deviation-from-equilibrium form.

args_rc = struct();

args_rc.type_rc = 'homotopy_rc_L96';
args_rc.N = 40;
args_rc.n = args_rc.N;

args_rc.F = 8;

args_rc.equ_vector = args_rc.F * ones(args_rc.N, 1);
args_rc.equ_value  = args_rc.F;

args_rc.h      = 0.5;
args_rc.p1     = 0.01;   % eps1: input-sensitivity exponent
args_rc.p2     = 1;      % eps2: equilibrium-proximity exponent
args_rc.var_l1 = 0.1;    % sigma_omega: rate (time-scale) noise
args_rc.var_l2 = 0;

rng('default');
args_rc.Win = randn(1, args_rc.N);

args_rc.r0 = 0.1 * randn(args_rc.N, 1);

end
