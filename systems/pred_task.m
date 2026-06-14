function [t_input, input, target] = pred_task(t, data)
% PRED_TASK  Prepare input-target pairs for one-step-ahead prediction.
%   [t_input, input, target] = pred_task(t, data)
%   input is the current state data(:,1:end-1); target is the next state data(:,2:end).

t_input = t(1:end-1);
input   = data(:, 1:end-1);
target  = data(:, 2:end);
end
