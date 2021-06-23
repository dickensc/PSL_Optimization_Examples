%% Load example
addpath("./loading_functions")
addpath("./smooth_helpers")

example_name = "epinions";

[hinge_potentials, square_hinge_potentials, ...
    linear_potentials, quadratic_potentials, ...
    constraints, meta_data] = load_example_data(example_name);

%% Initialize decision variables randomly in (0, 1).
x0 = rand(meta_data.Num_Variables, 1);

%% Example Smooth Problem Optimization. (Quadprog)
% Specify optimzation options.
options = optimoptions('quadprog','Display','iter-detailed', 'Diagnostics', 'on');

% Define QP.
[H, f, A, b, Aeq, beq, lb, ub] = get_qp_problem(hinge_potentials, ...
    square_hinge_potentials, linear_potentials, quadratic_potentials, ...
    constraints, meta_data);
%%
[x_smooth, fval, exitflag, output, lambda] = quadprog(H,f,A,b,Aeq,beq,lb,ub,x0,options);
x = x_smooth(1:meta_data.Num_Variables);
x_slack = x_smooth(meta_data.Num_Variables : end);

%% Adhoc Plot of results (Hardcoded Epinions Results)
t = linspace(0,12,13);
fval = [7.306427e+03, 9.459660e+03, 8.484374e+03, 2.258432e+03, ...
    9.099660e+02, 5.724310e+02, 4.794913e+02, 4.390656e+02, 4.284131e+02, ...
    4.231970e+02, 4.213697e+02, 4.200841e+02, 4.199690e+02];
plot(t, fval, 'Marker', 'd', 'Color', 'm', 'MarkerFaceColor', 'm', 'LineStyle', ':')
title('Objective Value')
xlabel('Epochs')
ylabel('Objective Value')

%% Adhoc Plot of results (Hardcoded Cora Results)
t = linspace(0,15,16);
fval = [1.512841e+04, 1.521760e+04, 1.620258e+04, 1.528806e+04, ...
    8.483221e+03, 3.639331e+03, 1.521432e+03, 6.934081e+02, 3.584906e+02, ...
    2.287068e+02, 1.956227e+02, 1.860223e+02, 1.837776e+02, 1.832569e+02, ...
    1.831800e+02, 1.831430e+02];
plot(t, fval, 'Marker', 'd', 'Color', 'm', 'MarkerFaceColor', 'm', 'LineStyle', ':')
title('Objective Value')
xlabel('Epochs')
ylabel('Objective Value')
set(gca, 'YScale', 'log')

%% Adhoc Plot of results (Hardcoded LastFM Results)
t = linspace(0,8,9);
fval = [7.007025e+05, 3.643277e+07, 3.248020e+07, 5.420902e+06, ...
    8.460064e+05, 2.421636e+05, 1.094466e+05, 3.095473e+04, 1.385122e+04];
plot(t, fval, 'Marker', 'd', 'Color', 'm', 'MarkerFaceColor', 'm', 'LineStyle', ':')
title('Objective Value')
xlabel('Epochs')
ylabel('Objective Value')
set(gca, 'YScale', 'log') 
