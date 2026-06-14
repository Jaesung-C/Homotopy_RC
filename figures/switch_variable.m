% SWITCH_VARIABLE
% Manuscript Figure 4: the homotopy switch variable s(t) of a coupled-Lorenz
% reservoir driven by the Rossler reconstruction task, where
%     s1 = (1 - exp(-p1*||u||)) * exp(-p2*||r - r_eq||).
% homotopy_rc_s1 records s1 into the last reservoir-state slot.

clc; clear; close all;
addpath(genpath(fullfile(fileparts(mfilename('fullpath')), '..')));
rng(0);

fprintf('=== Figure 4: homotopy switch variable s(t) ===\n');

% Driving task: Rossler reconstruction (same drive as Figure 2)
args_data = struct('eq_sys','eq_rossler','task','reconstruction', ...
                   'recon_in',1,'recon_out',3);
[t, data] = data_gen(args_data);
data(1,:) = data(1,:) / max(data(1,:));
[t_input, input, target, args_data] = task_gen(t, data, args_data);
[t_given, data_given, target_given, ~, ~, ~, args_data] = ...
    given_test_split(t_input, input, target, args_data, 'length', 0);

% Same parameters as the Figure-2 reconstruction (ep=13, var_l1=0.2, var_l2=10).
args_rc = homotopyDefaults();
args_rc.type_rc = 'homotopy_rc_s1';
args_rc.ep = 13;  args_rc.var_l1 = 0.2;  args_rc.var_l2 = 10;

% The switch variable s is read directly off u = Win*input, so it is sensitive
% to Win; Win is rebuilt here to reproduce the published figure. The manuscript
% text says Win is Uniform[-0.1,0.1], but the published Fig. 4 used the Gaussian
% form Win_a*(randn*2-1); to follow the text use Win_a*(2*rand(...)-1).
rng(0);
nWin = args_rc.n;
randn(nWin, nWin);                % intentional RNG-alignment draws (keep)
rand(nWin, nWin);                 % intentional RNG-alignment draws (keep)
args_rc.Win = args_rc.Win_a * (randn(nWin, args_data.inSize) * 2 - 1);

[~, r_train, ~, ~, ~, args_rc] = ...
    rc_train_state(t_given, data_given, target_given, args_data, args_rc);

s    = r_train(end, 1:1001);
time = (0:1000) / 10;            % h = 0.1
fprintf('Switch variable s: min=%.3f  max=%.3f  mean=%.3f\n', ...
        min(s), max(s), mean(s));

%% Figure
figure('Position', [100, 100, 1000, 320], 'Color', 'w');
plot(time, s, 'LineWidth', 1.5, 'Color', [0 0.45 0.74]);
xlim([0 100]);
xlabel('Time', 'FontSize', 13, 'FontWeight', 'bold');
ylabel('Switch variable, s', 'FontSize', 13, 'FontWeight', 'bold');
title('Homotopy switch variable s(t)', 'FontSize', 14, 'FontWeight', 'bold');
grid on; box on;

save_figure(gcf, 'switch_variable');
