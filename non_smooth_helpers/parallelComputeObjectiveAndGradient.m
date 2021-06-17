function [objective, gradient] = parallelComputeObjectiveAndGradient(potentials, x)
    % Compute the gradient of the objective defined by the potentials at the specifieid location: x.
    gradients = zeros(length(x), height(potentials));
    potential_values = zeros(1, height(potentials));
    
    var_indices = potentials.Var_Index;
    var_coefficients = potentials.Var_Coefficient;
    constants = potentials.Constant;
    weights = potentials.Weight;
    hinges = potentials.Hinge;
    squares = potentials.Square;
    
    parfor j=1: height(potentials)
        potential_indices = var_indices{j}{1};
        potential_coefficients = var_coefficients{j}{1};
        constant = constants(j);
        weight = weights(j);
        is_hinge = hinges(j);
        is_square = squares(j);
        % Compute potential Gradient and add to gradient.
        potential_gradient = computeFullNonSmoothPotentialGradient(x, potential_indices, potential_coefficients, constant, weight, is_hinge, is_square);
        potential_value = computeNonSmoothPotentialValue(x, potential_indices, potential_coefficients, constant, weight, is_hinge, is_square);
        
        gradients(:, j) = potential_gradient;
        potential_values(1, j) = potential_value;
    end
    gradient = sum(gradients, 2);
    objective = sum(potential_values, 2);
end

