function [x, objectives, gradients] = pslFrankWolfe(potentials, constraints, num_epochs, step_size_0, x0)
% pslFrankWolfe: Performs gradient descent on the inference problem defined by the 
%  provided potentials and constraints. Note that this implementation assumes that the 
%  [0,1] box constraints and simplex type constraints are the only constraints of the problem.

    % Store iterates.
    x = zeros(num_epochs, length(x0));
    x(1, :) = x0;

    % Initialize objective and gradients.
    objectives = zeros(num_epochs, 1);
    gradients = zeros(num_epochs, length(x0));
    
    % Determine simplex groups.
    var_indices = constraints.Var_Index;
    simplex_groups = zeros(height(constraints), length(x0));
    for i=1: height(constraints)
        constraint_indices = var_indices{i}{1};
        simplex_groups(i, constraint_indices) = ones(1, length(constraint_indices));
    end

    % Loop for num_epochs.
    for i=1: num_epochs
        step_size = step_size_0;
        % compute objective and gradient.
        [objectives(i), gradients(i, :)] = parallelComputeObjectiveAndGradient(potentials, x(i, :));
        % Determine x_tilde.
        x_tilde = max(-1 * sign(gradients(i, :)), 0);
        for j=1: height(simplex_groups)
            x_tilde(logical(simplex_groups(j, :))) = 0;
            simplex_gradient_mask = simplex_groups(j, :) .* gradients(i, :);
            [~, index] = min(simplex_gradient_mask);
            x_tilde(index) = 1;
        end
        % Frank-Wolfe step.
        x(i + 1, :) = x(i, :) + step_size * (x_tilde - x(i, :));
    end 
end

