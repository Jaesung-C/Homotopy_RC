function [out_train, out_val, args_rc] = ...
    rc_readout(r_train, target_train, r_val, args_data, args_rc)
% RC_READOUT  Train the linear readout via ridge regression.
%
% Solves  Wout = Y * R^T * (R*R^T + reg_p*I)^{-1}.  Only Wout is learned;
% reservoir weights stay fixed.  Falls back to pinv when reg_p is absent.

struct2vars(args_rc);

if exist('reg_p', 'var') && ~isempty(reg_p)
    Wout = target_train * r_train' / (r_train*r_train' + reg_p*eye(size(r_train,1)));
else
    Wout = target_train * pinv(r_train);
end

out_train = Wout * r_train;

if isfield(args_data, 'val_ratio') && ~isempty(r_val)
    out_val = Wout * r_val;
else
    out_val = [];
end

args_rc.Wout = Wout;
end
