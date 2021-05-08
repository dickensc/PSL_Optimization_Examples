function [objective] = evaluateNonSmoothObjective(x, potentials)
    % Evaluate objective given potentials.
    objective = 0;
    linear_val = 0;
    
    for i=1: height(potentials)
        linear_evaluation(potentials.Var_Index{i}, ...
            potentials.Var_Coefficient{i}, potentials.Constant(i));
        if potentials.Hinge(i) && potentials.Square(i)
            % Evaluate Square Hinge-loss
            objective = objective + potentials.Weight(i) * max(linear_val, 0.0)^2;
        elseif potentials.Hinge(i) && ~potentials.Square(i)
            % Evaluate Hinge-loss
            objective = objective + potentials.Weight(i) * max(linear_val, 0.0);
        elseif ~potentials.Hinge(i) && potentials.Square(i)
            % Evaluate Quadratic-loss
            objective = objective + potentials.Weight(i) * linear_val^2;
        elseif ~potentials.Hinge(i) && ~potentials.Square(i)
            % Evaluate Linear-loss
            objective = objective + potentials.Weight(i) * linear_val;
        end
    end
    
    function linear_evaluation(indices, coefficients, constant)
        linear_val = dot(x(indices{1}), coefficients{1}) - constant;
    end
end

