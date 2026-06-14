function args_rc = homotopyDefaults()
% HOMOTOPYDEFAULTS  Default parameters for the Lorenz-based HRC reservoir.
%
% Returns a parameter struct for N coupled Lorenz oscillators (3 states each,
% total dimension 3N) with all-to-all connectivity. var_l1, var_l2 and ep
% default to 0 and are typically overridden per experiment.

args_rc = struct();

args_rc.type_rc = 'homotopy_rc';

args_rc.N   = 100;
args_rc.n   = args_rc.N * 3;

args_rc.sig = 10;
args_rc.rho = 28;
args_rc.be  = 8/3;

args_rc.equix = -sqrt(args_rc.be * (args_rc.rho - 1));
args_rc.equiy = -sqrt(args_rc.be * (args_rc.rho - 1));
args_rc.equiz =  args_rc.rho - 1;

temp = repmat([args_rc.equix; args_rc.equiy; args_rc.equiz], 1, args_rc.N);
args_rc.equ_vector = reshape(temp, [], 1);

args_rc.A = ones(args_rc.N) - eye(args_rc.N);

args_rc.ep     = 0;
args_rc.h      = 0.1;
args_rc.p1     = 1;
args_rc.p2     = 1;
args_rc.var_l1 = 0;
args_rc.var_l2 = 0;

args_rc.Win_a = 0.1;
rng('default');
args_rc.Win = randn(1, 3*args_rc.N);

r0 = zeros(3*args_rc.N, 1);
r0(1:3:(3*args_rc.N-2)) = args_rc.equix;
r0(2:3:(3*args_rc.N-1)) = args_rc.equiy;
r0(3:3:3*args_rc.N)     = args_rc.equiz;
args_rc.r0 = r0 - args_rc.equ_vector;

end
