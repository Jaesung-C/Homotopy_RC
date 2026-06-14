function [rmse, nrmse1, nrmse2, mae] = metric_error(target, output)
% METRIC_ERROR  Compute four error metrics between target and predicted output.
%
% Returns RMSE, two NRMSEs (normalised by std and by RMS respectively), and MAE.
% Inputs are flattened to vectors internally.

err    = target(:) - output(:);
rmse   = sqrt(mean(err.^2));
nrmse1 = rmse / std(target(:));
nrmse2 = rmse / sqrt(mean(target(:).^2));
mae    = mean(abs(err));
end
