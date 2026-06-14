function struct2vars(s)
% STRUCT2VARS  Expand a struct's fields as variables in the caller workspace.
%
% Each field of struct s is assigned as a variable in the calling function,
% used throughout the pipeline to unpack parameter structs (args_rc, args_data).

for fname = fieldnames(s)'
    assignin('caller', fname{1}, s.(fname{1}));
end
end
