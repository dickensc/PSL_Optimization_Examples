function [objective] = evaluateNonSmoothObjective(x, potentials)
    % Evaluate objective given potentials.
    objective = 0;
    
    for i=1: height(potentials)
        potential_indices = potentials.Var_Index{i}{1};
        potential_coefficients = potentials.Var_Coefficient{i}{1};
        constant = potentials.Constant(i);
        weight = potentials.Weight(i);
        is_hinge = potentials.Hinge(i);
        is_square = potentials.Square(i);
        
        linear_val = dot(x(potential_indices), potential_coefficients) - constant;
        if is_hinge && is_square
            % Evaluate Square Hinge-loss
            objective = objective + weight * max(linear_val, 0.0)^2;
        elseif is_hinge && ~is_square
            % Evaluate Hinge-loss
            objective = objective + weight * max(linear_val, 0.0);
        elseif ~is_hinge && is_square
            % Evaluate Quadratic-loss
            objective = objective + potentials.Weight(i) * linear_val^2;
        elseif ~potentials.Hinge(i) && ~is_square
            % Evaluate Linear-loss
            objective = objective + weight * linear_val;
        end
    end
end

