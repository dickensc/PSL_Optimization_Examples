function [gradient] = computeNonSmoothPotentialGradient(x, potentials, i)
    % Compute the gradient of the provided potential, i, at the specifieid location: x.
    gradient = zeros(length(potentials.Var_Index{i}{1}), 1);
    
    linear_val = dot(x(potentials.Var_Index{i}{1}), potentials.Var_Coefficient{i}{1}) - potentials.Constant(i);
    if ((potentials.Hinge(i) && (linear_val > 0)) || ~potentials.Hinge(i)) && potentials.Square(i)
        gradient = 2 * potentials.Weight(i) * linear_val * potentials.Var_Coefficient{i}{1};
    elseif ((potentials.Hinge(i) && (linear_val > 0)) || ~potentials.Hinge(i)) && ~potentials.Square(i)
        gradient = potentials.Weight(i) * potentials.Var_Coefficient{i}{1};
    end
end

