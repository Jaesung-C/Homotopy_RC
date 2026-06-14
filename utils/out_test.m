function output_test = out_test(data_test, r_temp, args_data, args_rc)
% OUT_TEST  Open-loop test: drive reservoir with external input, apply readout.
%
% Runs the trained reservoir on held-out test data, supplying the ground-truth
% input at every step (signal-reconstruction task).

struct2vars(args_data);
struct2vars(args_rc);

rc_func = str2func(args_rc.type_rc);

r_test = zeros(n, testLen);
for t = 1:testLen
    r_temp      = rc_func(r_temp, data_test(:,t), args_rc);
    r_test(:,t) = r_temp;
end

output_test = Wout * r_test;
end
