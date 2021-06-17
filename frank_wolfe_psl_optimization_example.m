%% Load example. 
% Note: This currently assumes only simplex constraints.
% Note: Cora is currently the only example with strictly simplex constraints.

addpath("./loading_functions")
addpath("./non_smooth_helpers")

example_name = "cora";

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

%% Example Frank-Wolfe Implementation.
num_epochs = 250;
step_size = 0.1;

% Run Frank-Wolfe.
[x_non_smooth, objectives, gradients] = pslFrankWolfe(potentials, constraints, num_epochs, step_size, x0);

%% Frank-Wolfe Plots
figure
tiledlayout(2,1) % Requires R2019b or later

% Plot objectives per epoch
t_obj = linspace(0, length(objectives), length(objectives));
nexttile
plot(t_obj, objectives, 'Marker', 'd', 'Color', 'm', 'MarkerFaceColor', 'm', 'LineStyle', ':')
title('Objective Value')
xlabel('Epochs')
ylabel('Objective Value')
set(gca, 'YScale', 'log') 

% Plot gradient magnitudes per epoch
t_gradmag = linspace(0, num_epochs, num_epochs);
nexttile
plot(t_gradmag, vecnorm(gradients.'), 'Marker', 'd', 'Color', 'm', 'MarkerFaceColor', 'm', 'LineStyle', ':')
title('Gradient Magnitude')
xlabel('Epochs')
ylabel('Gradient Magnitude')
set(gca, 'YScale', 'log') 

saveas(gcf, sprintf('figures/%s_frank_wolfe_convergence.png', example_name));