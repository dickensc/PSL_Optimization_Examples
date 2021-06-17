function [value] = computeNonSmoothPotentialValue(x, potential_indices, potential_coefficients, constant, weight, is_hinge, is_square)
    % Evaluate objective given potentials.
    value = 0;
        
    linear_val = dot(x(potential_indices), potential_coefficients) - constant;
    if is_hinge && is_square
        % Evaluate Square Hinge-loss
        value = value + weight * max(linear_val, 0.0)^2;
    elseif is_hinge && ~is_square
        % Evaluate Hinge-loss
        value = value + weight * max(linear_val, 0.0);
    elseif ~is_hinge && is_square
        % Evaluate Quadratic-loss
        value = value + weight * linear_val^2;
    elseif ~is_hinge && ~is_square
        % Evaluate Linear-loss
        value = value + weight * linear_val;
    end
end

