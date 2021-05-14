function [objective, gradient] = computeObjectiveAndGradient(potentials, x)
    % Compuute the objective and gradient of the MAP inference objective
    %  defined by the potentials provided at the specified location: x.
    objective = evaluateNonSmoothObjective(potentials, x);
    gradient = computeNonSmoothGradient(potentials, x);
end

