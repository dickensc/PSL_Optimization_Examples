function [gradient] = computeNonSmoothPotentialGradient(x, potential_indices, potential_coefficients, constant, weight, is_hinge, is_square)
    % Compute the gradient of the provided potential, i, at the specifieid location: x.
    gradient = zeros(length(potential_indices), 1);
    
    linear_val = dot(x(potential_indices), potential_coefficients) - constant;
    if ((is_hinge && (linear_val > 0)) || ~is_hinge) && is_square
        gradient = 2 * weight * linear_val * potential_coefficients;
    elseif ((is_hinge && (linear_val > 0)) || ~is_hinge) && ~is_square
        gradient = weight * potential_coefficients;
    end
end

