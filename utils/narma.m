function [t_input, input, target] = narma(t, data, order)
% NARMA  Generate a Nonlinear AutoRegressive Moving Average (NARMA-N) sequence.
%
% Output follows the standard NARMA-N recursion:
%   y(t+1) = tanh( alpha*y(t) + beta*y(t)*sum_{i=0}^{N-1} y(t-i)
%                  + gamma*x(t-N+1)*x(t) + delta )
% Input data is 1-D (typically uniform random in [0,0.5]); the first 'order'
% target values are zero.

alpha = 0.3;
beta  = 0.05;
gamma = 1.5;
delta = 0.1;

x = data(1, :);
T = length(x);
y = zeros(1, T);

% Start at index 'order' to avoid out-of-bounds indexing
for k = order : T-1
    sum_y  = sum(y(k-order+1 : k));
    x_term = x(k-order+1) * x(k);
    y(k+1) = tanh(alpha*y(k) + beta*y(k)*sum_y + gamma*x_term + delta);
end

t_input = t;
input   = x;
target  = y;
end
