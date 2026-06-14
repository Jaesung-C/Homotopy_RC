function [t_input, input, target] = recon_task(t, data, recon_in, recon_out)
% RECON_TASK  Prepare input-target pairs for the signal reconstruction task.
%   [t_input, input, target] = recon_task(t, data, recon_in, recon_out)
%   The recon_in dimensions of data are fed as input; the reservoir
%   reconstructs the recon_out dimensions as target.

t_input = t(1:end-1);
input   = data(recon_in,  1:end-1);
target  = data(recon_out, 1:end-1);
end
