%% Load example
addpath("./loading_functions")
addpath("./smooth_helpers")

example_name = "epinions";

[hinge_potentials, square_hinge_potentials, ...
    linear_potentials, quadratic_potentials, ...
    constraints, meta_data] = load_example_data(example_name);

%% Initialize decision variables randomly in (0, 1).
x0 = rand(meta_data.Num_Variables, 1);

%% Example Smooth Problem Optimization.
% Define QP.
options = optimoptions('quadprog','Display','iter');
[H, f, A, b, Aeq, beq, lb, ub] = get_qp_problem(hinge_potentials, ...
    square_hinge_potentials, linear_potentials, quadratic_potentials, ...
    constraints, meta_data);
x_smooth = quadprog(H,f,A,b,Aeq,beq,lb,ub,x0,options);
x = x_smooth(1:meta_data.Num_Variables);
x_slack = x_smooth(meta_data.Num_Variables : end);