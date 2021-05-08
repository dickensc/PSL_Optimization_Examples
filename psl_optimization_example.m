%% Load example
addpath("./loading_functions")

example_name = "epinions";

[hinge_potentials, square_hinge_potentials, ...
    linear_potentials, quadratic_potentials, ...
    constraints, meta_data] = load_example_data(example_name);


%% Example Non-Smooth Problem Optimization. (SGD)

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

% Relax Constraints and add to potentials.
if height(constraints) > 0
    relaxed_constraints = constraints;
    relaxed_constraints.Weight = 100 * max(potentials.Weight);
    relaxed_constraints.Hinge = zeros(height(relaxed_constraints), 1, 'logical');
    relaxed_constraints.Square = zeros(height(relaxed_constraints), 1, 'logical');

    potentials = [potentials; relaxed_constraints];
end

% Initialize decision variables randomly in (0, 1).
x = rand(meta_data.Num_Variables);

