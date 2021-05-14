%% Load example
addpath("./loading_functions")
addpath("./smooth_helpers")

example_name = "epinions";

[hinge_potentials, square_hinge_potentials, ...
    linear_potentials, quadratic_potentials, ...
    constraints, meta_data] = load_example_data(example_name);


%% Example Smooth Problem Optimization.
% Define QP.
options = optimoptions('quadprog','Display','iter');
[H, f, A, b, Aeq, beq, lb, ub] = get_qp_problem(hinge_potentials, ...
    square_hinge_potentials, linear_potentials, quadratic_potentials, ...
    constraints, meta_data);
x = quadprog(H,f,A,b,Aeq,beq,lb,ub,x0,options);
