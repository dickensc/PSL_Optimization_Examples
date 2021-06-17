function [gradient] = computeFullNonSmoothPotentialGradient(x, potential_indices, potential_coefficients, constant, weight, is_hinge, is_square)
    % Compute the gradient of the provided potential, i, at the specified location: x.
    gradient = zeros(length(x), 1);
    gradient(potential_indices) = computeNonSmoothPotentialGradient(x, potential_indices, potential_coefficients, constant, weight, is_hinge, is_square);
end

