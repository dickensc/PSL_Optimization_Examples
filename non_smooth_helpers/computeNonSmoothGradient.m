function [gradient] = computeNonSmoothGradient(potentials, x)
    % Compute the gradient of the objective defined by the potentials at the specifieid location: x.
    gradient = zeros(length(x), 1);
    
    for j=1: height(potentials)
        potential_indices = potentials.Var_Index{j}{1};
        potential_coefficients = potentials.Var_Coefficient{j}{1};
        constant = potentials.Constant(j);
        weight = potentials.Weight(j);
        is_hinge = potentials.Hinge(j);
        is_square = potentials.Square(j);
        % Compute potential Gradient and add to gradient.
        potential_gradient = computeNonSmoothPotentialGradient(x, potential_indices, potential_coefficients, constant, weight, is_hinge, is_square);
        gradient(potential_indices) = gradient(potential_indices) + potential_gradient;
    end
end

