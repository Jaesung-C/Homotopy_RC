function [t_input, input, target, args_data] = task_gen(t, data, args_data)
% TASK_GEN  Prepare input-target pairs for a given RC task.
%
% args_data.task selects the task: 'reconstruction' (needs .recon_in/.recon_out),
% 'prediction' (one-step-ahead), or 'narma<N>' (e.g. 'narma10').  args_data
% gains fields .inputLen and .inSize.

taskName = args_data.task;

if startsWith(taskName, 'narma')
    order = str2double(extractAfter(taskName, 'narma'));
    if isnan(order)
        error('task_gen: cannot parse NARMA order from ''%s''.', taskName);
    end
    [t_input, input, target] = narma(t, data, order);

elseif strcmp(taskName, 'prediction')
    [t_input, input, target] = pred_task(t, data);

elseif strcmp(taskName, 'reconstruction')
    [t_input, input, target] = recon_task(t, data, args_data.recon_in, args_data.recon_out);

else
    error('task_gen: unsupported task ''%s''.', taskName);
end

args_data.inputLen = length(input);
args_data.inSize   = size(input, 1);
end
