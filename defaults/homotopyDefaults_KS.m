function args_rc = homotopyDefaults_KS()
% HOMOTOPYDEFAULTS_KS  Default parameters for the KS-based HRC reservoir.
%
% Returns a parameter struct for the Kuramoto-Sivashinsky PDE reservoir on
% domain [0, L] with N spatial points, integrated spectrally via ETDRK4.

args_rc = struct();

args_rc.type_rc = 'homotopy_rc_KS';
args_rc.N = 128;
args_rc.n = args_rc.N;

args_rc.L = 32*pi;
args_rc.x = args_rc.L * (0:args_rc.N-1)' / args_rc.N;

args_rc.kx       = (2*pi/args_rc.L) * [0:args_rc.N/2-1, 0, -args_rc.N/2+1:-1]';
args_rc.linear_op = args_rc.kx.^2 - args_rc.kx.^4;

args_rc.equ_vector = zeros(args_rc.N, 1);
args_rc.equ_value  = 0;

args_rc.h      = 0.2;
args_rc.p1     = 0.1;    % eps1: input-sensitivity exponent
args_rc.p2     = 0.01;   % eps2: equilibrium-proximity exponent
args_rc.var_l1 = 0.1;    % sigma_omega: rate (time-scale) noise
args_rc.var_l2 = 0.1;

rng('default');
args_rc.Win = 0.1 * randn(1, args_rc.N);

args_rc.r0 = 0.1*cos(args_rc.x/16) .* (1 + sin(args_rc.x/16));

% ETDRK4 complex-contour quadrature settings
args_rc.etd_M = 16;
args_rc.etd_r = exp(1i*pi*((1:args_rc.etd_M)'-0.5)/args_rc.etd_M);

end
