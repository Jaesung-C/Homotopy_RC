% RECONSTRUCTION
% Manuscript Figure 2: Rossler attractor reconstruction with Homotopy RC.
% Observe Rossler x and reconstruct (y, z) with three reservoir substrates:
% (a) coupled Lorenz, (b) Lorenz-96, (c) Kuramoto-Sivashinsky. Black = truth,
% red = reconstruction.

clc; clear; close all;
addpath(genpath(fullfile(fileparts(mfilename('fullpath')), '..')));

testLen = 10000;

% Coupled Lorenz needs explicit couplings; L96/KS use their built-in defaults.
fprintf('=== Figure 2: Rossler reconstruction ===\n');
[xa, ya_t, za_t, ya_r, za_r, ny_a, nz_a] = ...
    recon_yz(@homotopyDefaults,     struct('ep',13,'var_l1',0.2,'var_l2',10), testLen);
fprintf('(a) Coupled Lorenz : y NRMSE2=%.5f  z NRMSE2=%.5f\n', ny_a, nz_a);

[xb, yb_t, zb_t, yb_r, zb_r, ny_b, nz_b] = ...
    recon_yz(@homotopyDefaults_L96, struct(), testLen);
fprintf('(b) Lorenz-96      : y NRMSE2=%.5f  z NRMSE2=%.5f\n', ny_b, nz_b);

[xc, yc_t, zc_t, yc_r, zc_r, ny_c, nz_c] = ...
    recon_yz(@homotopyDefaults_KS,  struct(), testLen);
fprintf('(c) Kuramoto-Sivashinsky : y NRMSE2=%.5f  z NRMSE2=%.5f\n', ny_c, nz_c);

%% Figure
figure('Position', [100, 100, 1800, 520], 'Color', 'w');
titles = {'(a) Coupled Lorenz', '(b) Lorenz-96', '(c) Kuramoto-Sivashinsky'};
X = {xa, xb, xc};  Yt = {ya_t, yb_t, yc_t};  Zt = {za_t, zb_t, zc_t};
Yr = {ya_r, yb_r, yc_r};  Zr = {za_r, zb_r, zc_r};
nY = [ny_a, ny_b, ny_c];  nZ = [nz_a, nz_b, nz_c];

for p = 1:3
    ax = subplot(1, 3, p);
    plot3(ax, X{p}, Yt{p}, Zt{p}, 'k-', 'LineWidth', 1.5); hold(ax, 'on');
    plot3(ax, X{p}, Yr{p}, Zr{p}, 'r-', 'LineWidth', 1.5); hold(ax, 'off');
    title(ax, titles{p}, 'FontSize', 16, 'FontWeight', 'bold');
    xlabel(ax, 'x', 'FontSize', 14); ylabel(ax, 'y', 'FontSize', 14);
    zlabel(ax, 'z', 'FontSize', 14);
    xlim(ax, [-10 12]); ylim(ax, [-12 10]); zlim(ax, [0 23]);
    grid(ax, 'on'); box(ax, 'on'); view(ax, 40, 30);
    text(ax, 0.02, 0.95, sprintf('NRMSE_2(y)=%.5f\nNRMSE_2(z)=%.5f', nY(p), nZ(p)), ...
        'Units', 'normalized', 'FontSize', 11, 'VerticalAlignment', 'top', ...
        'BackgroundColor', [1 1 1 0.6]);
    if p == 1
        legend(ax, {'Ground truth', 'Reconstructed'}, 'Location', 'north', 'FontSize', 12);
    end
end

save_figure(gcf, 'reconstruction', 'image');

function [x_obs, y_true, z_true, y_rc, z_rc, nrmse_y, nrmse_z] = ...
        recon_yz(defFun, overrides, testLen)
% Reconstruct Rossler y and z from observed x using the given reservoir.
    [x_obs, y_true, y_rc, nrmse_y] = recon_one(defFun, overrides, 2, testLen);
    [~,     z_true, z_rc, nrmse_z] = recon_one(defFun, overrides, 3, testLen);
end

function [x_obs, target_test, output, nrmse2] = recon_one(defFun, overrides, recon_out, testLen)
    rng(0);
    args_data = struct('eq_sys','eq_rossler','task','reconstruction', ...
                       'recon_in',1,'recon_out',recon_out);
    [t, data] = data_gen(args_data);
    max_in = max(abs(data(1,:)));
    data(1,:) = data(1,:) / max_in;
    [t_input, input, target, args_data] = task_gen(t, data, args_data);
    [t_given, data_given, target_given, ~, data_test, target_test, args_data] = ...
        given_test_split(t_input, input, target, args_data, 'length', testLen);
    args_rc = defFun();
    fn = fieldnames(overrides);
    for i = 1:numel(fn), args_rc.(fn{i}) = overrides.(fn{i}); end
    [r_temp, r_train, target_train, r_val, ~, args_rc] = ...
        rc_train_state(t_given, data_given, target_given, args_data, args_rc);
    [~, ~, args_rc] = rc_readout(r_train, target_train, r_val, args_data, args_rc);
    output = out_test(data_test, r_temp, args_data, args_rc);
    [~, ~, nrmse2, ~] = metric_error(target_test, output);
    x_obs = data_test * max_in;
end
