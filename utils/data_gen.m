function [t, data] = data_gen(args_data)
% DATA_GEN  Generate time-series data from a specified dynamical system.
%
% args_data.eq_sys names the ODE function (e.g. 'eq_rossler', 'eq_lorenz');
% missing fields are filled from [eq_sys]Defaults.  Optional .dim_sel returns
% only a subset of state dimensions.

args_data = defaults2args(args_data);
struct2vars(args_data);

if ~isfield(args_data, 'parm')
    args_data.parm = args_data.parms;
end

Solver = str2func(solver);
[t, data] = Solver(eq_sys, x0, args_data);

if isfield(args_data, 'dim_sel')
    data = data(dim_sel, :);
end
end
