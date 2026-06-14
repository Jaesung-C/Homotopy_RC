function pred = long_pred(~, target_test, r_temp, args_data, args_rc)
% LONG_PRED  Closed-loop autonomous prediction (reservoir feeds back its output).
%
% After training the external input is detached and the readout output is fed
% back as input each step, generating long trajectories of the target system.
% target_test is used only for its size, not as input.

struct2vars(args_data);
struct2vars(args_rc);

rc_func = str2func(args_rc.type_rc);

pred = zeros(size(target_test, 1), testLen);

u = Wout * r_temp;

for t = 1:testLen
    r_temp  = rc_func(r_temp, u, args_rc);   % feedback previous output
    u       = Wout * r_temp;
    pred(:,t) = u;
end
end
