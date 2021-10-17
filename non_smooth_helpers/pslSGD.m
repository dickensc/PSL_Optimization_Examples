function [x, objectives, gradients] = pslSGD(potentials, num_epochs, step_size_0, x0)
% pslSGD: Performs SGD on inference problem defined with potentials.
%  Note that this implementation assumes that the [0,1] box constraints are 
%  the only constraints of the problem.

    % Store iterates.
    x = zeros(num_epochs, length(x0));
    x(1, :) = x0;

    % Initialize objective and gradients.
    objectives = zeros(num_epochs, 1);
    gradients = zeros(num_epochs, length(x0));
    
    % Loop for num_epochs.
    for i=1: num_epochs
        step_size =  step_size_0 / (i);
        % compute objective and gradient.
        [objectives(i), gradients(i, :)] = computeObjectiveAndGradient(potentials, x(i, :));
        % copy previous epoch location.
        x(i + 1, :) = x(i, :);
        
        potential_permutation = randperm(height(potentials));
        for j=1: height(potentials)
            permutation_index = potential_permutation(j);
            potential_indices = potentials.Var_Index{permutation_index}{1};
            potential_coefficients = potentials.Var_Coefficient{permutation_index}{1};
            constant = potentials.Constant(permutation_index);
            weight = potentials.Weight(permutation_index);
            is_hinge = potentials.Hinge(permutation_index);
            is_square = potentials.Square(permutation_index);
            gradient = computeNonSmoothPotentialGradient(x(i + 1, :).', potential_indices, potential_coefficients, constant, weight, is_hinge, is_square);
            % SGD step.
            x(i + 1, potential_indices) = x(i + 1, potential_indices).' - step_size * gradient;
            % Clip for box constraints.
            x(i + 1, potential_indices) = max(min(x(i + 1, potential_indices), 1), 0);
        end
    end
end

