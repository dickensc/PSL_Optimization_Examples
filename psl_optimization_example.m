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

%  SGD
num_epochs = 1;
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
x = rand(meta_data.Num_Variables, 1);

% Evaluate initial objective.
objectives = zeros(num_epochs + 1, 1);
objectives(1) = evaluateNonSmoothObjective(x, potentials);

%% SGD Optimization.
for i=1: num_epochs
    potential_permutation = randperm(height(potentials));
    for j=1: height(potentials)
        % SGD step
        x(potentials.Var_Index{potential_permutation(j)}{1}) = (x(potentials.Var_Index{potential_permutation(j)}{1}) ...
            - step_size * computeNonSmoothPotentialGradient(x, potentials, potential_permutation(j)));
        % Clip for box constraints
        x(potentials.Var_Index{potential_permutation(j)}{1}) = min(max(min(x(potentials.Var_Index{potential_permutation(j)}{1}), 1), 0), 1);
    end
    % Evaluate objective after epoch.
    objectives(i) = evaluateNonSmoothObjective(x, potentials);
end
