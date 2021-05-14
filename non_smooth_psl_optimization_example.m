%% Load example
addpath("./loading_functions")
addpath("./non_smooth_helpers")

example_name = "epinions";

[hinge_potentials, square_hinge_potentials, ...
    linear_potentials, quadratic_potentials, ...
    constraints, meta_data] = load_example_data(example_name);


%% Aggregate Potentials into single table.

% Concatenate Potentials into one table.
hinge_potentials.Hinge = ones(height(hinge_potentials), 1, 'logical');
hinge_potentials.Square = zeros(height(hinge_potentials), 1, 'logical');

square_hinge_potentials.Hinge = ones(height(square_hinge_potentials), 1, 'logical');
square_hinge_potentials.Square = ones(height(square_hinge_potentials), 1, 'logical');

linear_potentials.Hinge = zeros(height(linear_potentials), 1, 'logical');
linear_potentials.Square = zeros(height(linear_potentials), 1, 'logical');

quadratic_potentials.Hinge = zeros(height(quadratic_potentials), 1, 'logical');
quadratic_potentials.Square = ones(height(quadratic_potentials), 1, 'logical');

potentials = [hinge_potentials; square_hinge_potentials; linear_potentials; quadratic_potentials];

%% Initialize decision variables randomly in (0, 1).
x0 = rand(meta_data.Num_Variables, 1);

%% Example SGD Implementation.
num_epochs = 100;
step_size = 0.01;

% Relax Constraints and add to potentials.
if height(constraints) > 0
    relaxed_constraints = constraints;
    relaxed_constraints.Weight = 100 * max(potentials.Weight);
    relaxed_constraints.Hinge = zeros(height(relaxed_constraints), 1, 'logical');
    relaxed_constraints.Square = zeros(height(relaxed_constraints), 1, 'logical');

    potentials = [potentials; relaxed_constraints];
end

% Run SGD. x is all of the iterates and objectives are at every epoch.
[x, objectives] = pslSGD(potentials, num_epochs, step_size, x0);

%% Example use of MATLAB Non-linear Optimization Toolbox

% Reset potentials table
potentials = [hinge_potentials; square_hinge_potentials; linear_potentials; quadratic_potentials];

% Define objective and gradient function.
fun = @(x0)computeObjectiveAndGradient(potentials, x0);

% Set optimoptions.
options = optimoptions('fmincon', 'SpecifyObjectiveGradient', true, 'Display','iter');

% Constraints.
A = sparse(height(constraints), meta_data.Num_Variables);
b = zeros(height(constraints), 1);
for i = 1: height(constraints)
    var_indices = constraints.Var_Index{i}{1};
    var_coefficients = constraints.Var_Coefficient{i}{1};
    constant = constraints.Constant(i);

    A(i, var_indices) = var_coefficients;
    b(i) = constant;
end

% Remaining parameters.
Aeq = [];
beq = [];
lb = zeros(length(x0),1);
ub = ones(length(x0),1);

x = fmincon(fun, x0, A, b, Aeq, beq, lb, ub, [], options);
