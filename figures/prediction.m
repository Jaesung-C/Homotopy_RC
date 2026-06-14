% PREDICTION
% Manuscript Figure 3: closed-loop prediction of the Mackey-Glass series with a
% coupled-Lorenz Homotopy RC. (a) first 1000 test steps; (b) last 1000 test steps.

clc; clear; close all;
addpath(genpath(fullfile(fileparts(mfilename('fullpath')), '..')));
rng(0);

fprintf('=== Figure 3: Mackey-Glass real-time prediction ===\n');
args_data = struct('eq_sys','eq_mackey','task','prediction');
[t, data] = data_gen(args_data);
data = data / max(data);
[t_input, input, target, args_data] = task_gen(t, data, args_data);
[t_given, data_given, target_given, ~, data_test, target_test, args_data] = ...
    given_test_split(t_input, input, target, args_data, 'length', 10000);

args_rc = homotopyDefaults();
args_rc.ep = 7; args_rc.var_l1 = 0.2; args_rc.var_l2 = 10;

[r_temp, r_train, target_train, r_val, ~, args_rc] = ...
    rc_train_state(t_given, data_given, target_given, args_data, args_rc);
[~, ~, args_rc] = rc_readout(r_train, target_train, r_val, args_data, args_rc);

pred = long_pred(data_test, target_test, r_temp, args_data, args_rc);
[~, ~, nrmse2_1k, ~] = metric_error(target_test(1,1:1000), pred(1,1:1000));
fprintf('First-1000-step NRMSE2 = %.5f (accurate tracking)\n', nrmse2_1k);

%% Figure
figure('Position', [100, 100, 1500, 600], 'Color', 'w');

subplot(2,1,1);
plot(1:1000, pred(1,1:1000),        'r-', 'LineWidth', 1.2); hold on;
plot(1:1000, target_test(1,1:1000), 'k-', 'LineWidth', 1.2); hold off;
ylabel('State value', 'FontSize', 12, 'FontWeight', 'bold');
title('(a) First 1000 real-time predictions', 'FontSize', 14, 'FontWeight', 'bold');
legend({'Predicted','Ground truth'}, 'Location', 'southeast', 'FontSize', 10);

subplot(2,1,2);
xv = 9001:10000;
plot(xv, pred(1,end-999:end),        'r-', 'LineWidth', 1.2); hold on;
plot(xv, target_test(1,end-999:end), 'k-', 'LineWidth', 1.2); hold off;
xlabel('Time step', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('State value', 'FontSize', 12, 'FontWeight', 'bold');
title('(b) Last 1000 real-time predictions', 'FontSize', 14, 'FontWeight', 'bold');
legend({'Predicted','Ground truth'}, 'Location', 'southeast', 'FontSize', 10);

save_figure(gcf, 'prediction');
