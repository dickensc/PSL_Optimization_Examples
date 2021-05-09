%% Load example
addpath("./loading_functions")

example_name = "epinions";

[hinge_potentials, square_hinge_potentials, ...
    linear_potentials, quadratic_potentials, ...
    constraints, meta_data] = load_example_data(example_name);


%% Example Non-Smooth Problem Optimization.

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

% SGD.
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

% Initialize decision variables randomly in (0, 1).
x_non_smooth = rand(meta_data.Num_Variables, 1);

% Evaluate initial objective.
objectives = zeros(num_epochs + 1, 1);
objectives(1) = evaluateNonSmoothObjective(x_non_smooth, potentials);

% Loop for num_epochs.
for i=1: num_epochs
    potential_permutation = randperm(height(potentials));
    for j=1: height(potentials)
        permutation_index = potential_permutation(j);
        potential_indices = potentials.Var_Index{permutation_index}{1};
        potential_coefficients = potentials.Var_Coefficient{permutation_index}{1};
        constant = potentials.Constant(permutation_index);
        weight = potentials.Weight(permutation_index);
        is_hinge = potentials.Hinge(permutation_index);
        is_square = potentials.Square(permutation_index);
        % SGD step.
        x_non_smooth(potential_indices) = (x_non_smooth(potential_indices) - step_size * computeNonSmoothPotentialGradient(x_non_smooth, potential_indices, potential_coefficients, constant, weight, is_hinge, is_square));
        % Clip for box constraints.
        x_non_smooth(potential_indices) = min(max(min(x_non_smooth(potential_indices), 1), 0), 1);
    end
    % Evaluate objective after epoch.
    objectives(i) = evaluateNonSmoothObjective(x_non_smooth, potentials);
end

%% Example Smooth Problem Optimization.
smooth_num_variables = meta_data.Num_Variables + height(square_hinge_potentials) + height(hinge_potentials);

% Quadratic Potentials.
Q_Q = sparse(height(quadratic_potentials), smooth_num_variables);
b_Q = sparse(smooth_num_variables, 1);
for i = 1: height(quadratic_potentials)
    var_indices = quadratic_potentials.Var_Index{i}{1};
    var_coefficients = quadratic_potentials.Var_Coefficient{i}{1};
    constant = quadratic_potentials.Constant(i);
    weight = quadratic_potentials.Weight(i);
    
    
    Q_Q(var_indices, var_indices) = Q_Q(var_indices, var_indices) + weight * (var_coefficients * var_coefficients'); 
    b_Q(var_indices) = b_Q(var_indices) - 2 * weight * constant * var_coefficients;
end

% Linear Potentials.
b_L = sparse(smooth_num_variables, 1);
for i = 1: height(linear_potentials)
    var_indices = linear_potentials.Var_Index{i}{1};
    var_coefficients = linear_potentials.Var_Coefficient{i}{1};
    constant = linear_potentials.Constant(i);
    weight = linear_potentials.Weight(i);
    
    b_L(var_indices) = b_L(var_indices) + weight * var_coefficients;
end

% Square Hinge Potentials.
Q_SH = sparse(height(square_hinge_potentials), smooth_num_variables);
A_SH = sparse(height(square_hinge_potentials), smooth_num_variables);
c_SH = sparse(height(square_hinge_potentials), 1);
for i = 1: height(square_hinge_potentials)
    var_indices = square_hinge_potentials.Var_Index{i}{1};
    var_coefficients = square_hinge_potentials.Var_Coefficient{i}{1};
    constant = square_hinge_potentials.Constant(i);
    weight = square_hinge_potentials.Weight(i);

    Q_SH(i, meta_data.Num_Variables + i) = weight;
    A_SH(i, var_indices) = var_coefficients;
    A_SH(i, meta_data.Num_Variables + i) = -1;
    c_SH(i) = constant;
end

% Linear Hinge Potentials.
b_H = sparse(smooth_num_variables, 1);
A_H = sparse(height(hinge_potentials), smooth_num_variables);
c_H = sparse(height(hinge_potentials), 1);
for i = 1: height(hinge_potentials)
    var_indices = hinge_potentials.Var_Index{i}{1};
    var_coefficients = hinge_potentials.Var_Coefficient{i}{1};
    constant = hinge_potentials.Constant(i);
    weight = hinge_potentials.Weight(i);

    b_H(meta_data.Num_Variables + height(square_hinge_potentials) + i) = weight;
    A_H(i, var_indices) = var_coefficients;
    A_H(i, meta_data.Num_Variables + height(square_hinge_potentials) + i) = -1;
    c_H(i) = constant;
end

% Constraints.
A_C = sparse(height(constraints), smooth_num_variables);
c_C = sparse(height(constraints), 1);
for i = 1: height(constraints)
    var_indices = hinge_potentials.Var_Index{i}{1};
    var_coefficients = hinge_potentials.Var_Coefficient{i}{1};
    constant = hinge_potentials.Constant(i);
    weight = hinge_potentials.Weight(i);
    
    A_C(i, var_indices) = var_coefficients;
    c_C(i) = constant;
end

% Box constraints on x.
A_box = sparse(meta_data.Num_Variables * 2, smooth_num_variables);
c_box = [ones(meta_data.Num_Variables, 1); zeros(meta_data.Num_Variables, 1)];
for i = 1: (meta_data.Num_Variables)
    A_box(i, i) = 1;
    A_box(i + meta_data.Num_Variables, i) = -1;
end

% Slack Potentials.
A_slack = sparse(height(hinge_potentials) + height(square_hinge_potentials), smooth_num_variables);
c_slack = zeros((height(hinge_potentials) + height(square_hinge_potentials)), 1);
for i = 1: (height(hinge_potentials) + height(square_hinge_potentials))
    A_slack(i, meta_data.Num_Variables + i) = -1;
end

% Define QP.
options = optimoptions('quadprog','Display','iter');
H = [Q_Q;Q_SH];
f = b_Q + b_L + b_H;
A = [A_SH; A_H; A_C; A_box; A_slack];
b = [c_SH; c_H; c_C; c_box; c_slack];
Aeq = [];
beq = [];
lb = [];
ub = [];
x0 = [];
x_smooth = quadprog(H,f,A,b,Aeq,beq,lb,ub,x0,options);
