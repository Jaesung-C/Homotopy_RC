% CONCEPT
% Conceptual illustration of Homotopy RC (Figure 1) using the Lorenz-96 system:
% (a) free-running L96 chaos; (b) embedded L96 reservoir excited on an input
% window then relaxing back. Both panels show deviation from equilibrium x_i = F.

clc; clear; close all;
addpath(genpath(fullfile(fileparts(mfilename('fullpath')), '..')));

fprintf('=== Fig1 (Lorenz-96-only concept illustration) ===\n');

nSteps = 200;
win    = [70 130];       % input window in column units (dashed lines)
A      = 8;
freq   = 1/20;
t      = 1:nSteps;

%% (a) Free-running Lorenz-96
p  = homotopyDefaults_L96();
N  = p.N;  F = p.F;
dt = 0.05;  sub = 3;     % advance `sub` RK4 steps per recorded frame
rng(0);
x = F + 0.1*randn(N,1);
for w = 1:400, x = rk4_l96(x, dt, F); end          % discard transient
Ua = zeros(N, nSteps);
for k = 1:nSteps
    for s = 1:sub, x = rk4_l96(x, dt, F); end
    Ua(:,k) = x - F;
end

%% (b) Embedded Lorenz-96 HRC driven on the input window
% Small chaos weight (gentle p1, strong p2) keeps the explicit h=0.5 step stable.
b = homotopyDefaults_L96();
b.p1 = 0.1;  b.p2 = 1;  b.var_l1 = 0.1;
pulse = @(k) sin(2*pi*freq*(k - win(1))) .* (k >= win(1) & k <= win(2));
r  = zeros(b.N, 1);  Ub = zeros(b.N, nSteps);
for k = 1:nSteps
    r = homotopy_rc_L96(r, A * pulse(k), b);
    Ub(:,k) = r;
end

%% Figure
figure('Position', [100, 100, 1500, 480], 'Color', 'w');

ax1 = axes('Position', [0.06 0.15 0.37 0.74]);
imagesc(ax1, t, 1:N, Ua); set(ax1, 'YDir', 'normal'); colormap(ax1, jet); colorbar(ax1);
title(ax1, '(a) Free-running Lorenz-96', 'FontSize', 15, 'FontWeight', 'bold');
xlabel(ax1, 'Time', 'FontSize', 13); ylabel(ax1, 'Site index i', 'FontSize', 13);

ax2 = axes('Position', [0.58 0.15 0.37 0.74]);
imagesc(ax2, t, 1:N, Ub); set(ax2, 'YDir', 'normal'); colormap(ax2, jet); colorbar(ax2);
hold(ax2, 'on');
xline(ax2, win(1), '--k', 'LineWidth', 1.2);
xline(ax2, win(2), '--k', 'LineWidth', 1.2); hold(ax2, 'off');
title(ax2, '(b) Embedded Lorenz-96 Reservoir', 'FontSize', 15, 'FontWeight', 'bold');
xlabel(ax2, 'Time', 'FontSize', 13); ylabel(ax2, 'Site index i', 'FontSize', 13);

annotation('arrow', [0.475 0.525], [0.52 0.52], 'LineWidth', 2.5, ...
           'HeadWidth', 14, 'HeadLength', 14);

save_figure(gcf, 'concept', 'image');

function x = rk4_l96(x, dt, F)
    k1 = l96_rhs(x, F);
    k2 = l96_rhs(x + dt/2*k1, F);
    k3 = l96_rhs(x + dt/2*k2, F);
    k4 = l96_rhs(x + dt*k3,   F);
    x  = x + dt/6*(k1 + 2*k2 + 2*k3 + k4);
end

function d = l96_rhs(x, F)
    % Lorenz-96:  dx_i/dt = (x_{i+1} - x_{i-2})*x_{i-1} - x_i + F   (cyclic)
    d = (circshift(x,-1) - circshift(x,2)) .* circshift(x,1) - x + F;
end

