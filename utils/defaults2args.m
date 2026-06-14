function args_data = defaults2args(args_data)
% DEFAULTS2ARGS  Fill missing fields of args_data with system defaults.
%
% Looks up the function [args_data.eq_sys 'Defaults'] (e.g. 'eq_rosslerDefaults')
% and copies any field not already present in args_data from it.

defaultFuncName = [args_data.eq_sys 'Defaults'];

if exist(defaultFuncName, 'file') ~= 2
    error('defaults2args: Default function ''%s'' not found on MATLAB path.', defaultFuncName);
end

defaults  = feval(defaultFuncName);
fnDef     = fieldnames(defaults);

for k = 1:numel(fnDef)
    if ~isfield(args_data, fnDef{k})
        args_data.(fnDef{k}) = defaults.(fnDef{k});
    end
end
end
