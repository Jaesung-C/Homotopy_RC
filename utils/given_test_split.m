function [t_given, data_given, target_given, t_test, data_test, target_test, args_data] = ...
    given_test_split(t_input, input, target, args_data, varargin)
% GIVEN_TEST_SPLIT  Split data into training (given) and test sets.
%
% Name-Value 'ratio' sets the test fraction in [0,1]; 'length' (test steps)
% overrides it when given.  args_data gains fields .givenLen and .testLen.

p = inputParser;
addParameter(p, 'ratio',  0,  @(x) x>=0 && x<=1);
addParameter(p, 'length', [], @(x) isempty(x) || (isnumeric(x) && x>=0));
parse(p, varargin{:});

numSamples = length(t_input);
testLen    = p.Results.length;

if isempty(testLen)
    testLen = round(numSamples * p.Results.ratio);
end

if testLen > numSamples
    error('given_test_split: test length (%d) exceeds total samples (%d).', testLen, numSamples);
end

givenLen = numSamples - testLen;

t_given       = t_input(1:givenLen);
data_given    = input(:,  1:givenLen);
target_given  = target(:, 1:givenLen);

t_test        = t_input(givenLen+1:end);
data_test     = input(:,  givenLen+1:end);
target_test   = target(:, givenLen+1:end);

args_data.givenLen = givenLen;
args_data.testLen  = testLen;
end
