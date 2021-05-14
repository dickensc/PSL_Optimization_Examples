function [x, objectives] = pslSGD(potentials, num_epochs, step_size, x0)
% pslSGD: Performs SGD on inference problem defined with potentials.
%  Note that this implementation assumes that the [0,1] box constraints are 
%  the only constraints of the problem.

    % Store iterates.
    x = zeros(num_epochs * height(potentials), length(x0));
    x(1, :) = x0;
    k = 2;

    % Evaluate initial objective.
    objectives = zeros(num_epochs + 1, 1);
    objectives(1) = evaluateNonSmoothObjective(potentials, x0);

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
            gradient = computeNonSmoothPotentialGradient(x(k-1, :).', potential_indices, potential_coefficients, constant, weight, is_hinge, is_square);
            % SGD step.
            x(k, :) = x(k - 1, :);
            x(k, potential_indices) = x(k-1, potential_indices).' - step_size * gradient;
            % Clip for box constraints.
            x(k, potential_indices) = min(max(min(x(k, potential_indices), 1), 0), 1);
            k = k + 1;
        end
        % Evaluate objective after epoch.
        objectives(i + 1) = evaluateNonSmoothObjective(potentials, x(k - 1, :).');
    end
end

