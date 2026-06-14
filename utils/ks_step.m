function u_next = ks_step(u, args_rc)
% KS_STEP  Advance the Kuramoto-Sivashinsky equation by one step via ETDRK4.
%
%   u_t + u*u_x + u_xx + u_xxxx = 0
%
% Spectral (FFT) spatial discretisation with 4th-order Exponential Time
% Differencing Runge-Kutta time stepping (step size h).

N         = args_rc.N;
h         = args_rc.h;
kx        = args_rc.kx;
linear_op = args_rc.linear_op;
var_l2    = args_rc.var_l2;
etd_r     = args_rc.etd_r;
etd_M     = args_rc.etd_M;

% Optional small noise on the linear operator (chaoticity diversity)
noisy_linear_op = linear_op .* (1 + var_l2 * randn(N, 1) * 0.01);

u_hat = fft(u);

E  = exp(h   * noisy_linear_op);
E2 = exp(h/2 * noisy_linear_op);

Nhat  = @(v) -0.5 * 1i * kx .* fft(v.^2);
N_hat = Nhat(u);

% ETDRK4 coefficients via complex-contour quadrature
LR = h * noisy_linear_op(:, ones(etd_M,1)) + etd_r(ones(N,1), :);
Q  = h * real(mean((exp(LR/2) - 1) ./ LR, 2));
f1 = h * real(mean((-4 - LR + exp(LR).*(4 - 3*LR + LR.^2)) ./ LR.^3, 2));
f2 = h * real(mean(( 2 + LR + exp(LR).*(-2 + LR))          ./ LR.^3, 2));
f3 = h * real(mean((-4 - 3*LR - LR.^2 + exp(LR).*(4 - LR)) ./ LR.^3, 2));

a  = E2.*u_hat + Q.*N_hat;   Na = Nhat(real(ifft(a)));
b  = E2.*u_hat + Q.*Na;      Nb = Nhat(real(ifft(b)));
c  = E2.*a + Q.*(2*Nb - N_hat); Nc = Nhat(real(ifft(c)));

u_hat_next = E.*u_hat + N_hat.*f1 + 2*(Na+Nb).*f2 + Nc.*f3;
u_next = real(ifft(u_hat_next));
end
