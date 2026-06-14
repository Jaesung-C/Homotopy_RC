function [r_temp, r_train, target_train, r_val, target_val, args_rc] = ...
    rc_train_state(t_given, data_given, target_given, args_data, args_rc)
% RC_TRAIN_STATE  Drive the reservoir with training data and collect states.
%
% Runs the reservoir over the training sequence, discards the first 1000
% steps as washout, and splits the rest into training and (optional)
% validation sets when args_data.val_ratio is defined.

struct2vars(args_data);
struct2vars(args_rc);

rc_func = str2func(args_rc.type_rc);

warmupLen = 1000;

if isfield(args_data, 'val_ratio')
    valLen   = round(args_data.val_ratio * (givenLen - warmupLen));
    trainLen = givenLen - warmupLen - valLen;
else
    trainLen = givenLen - warmupLen;
    r_val         = [];
    target_val    = [];
end

r_given = zeros(n, givenLen);
if ~isfield(args_rc, 'r0')
    r0 = zeros(n, 1);
end
r_given(:,1) = rc_func(r0, data_given(:,1), args_rc);

for t = 2:givenLen
    r_given(:,t) = rc_func(r_given(:,t-1), data_given(:,t), args_rc);
end

r_temp = r_given(:, end);   % seed for test phase

r_train       = r_given(:,      warmupLen+1 : warmupLen+trainLen);
target_train  = target_given(:, warmupLen+1 : warmupLen+trainLen);

if isfield(args_data, 'val_ratio')
    r_val      = r_given(:,      warmupLen+trainLen+1 : givenLen);
    target_val = target_given(:, warmupLen+trainLen+1 : givenLen);
end
end
