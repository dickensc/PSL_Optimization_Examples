function [x, objectives, gradients] = pslGD(potentials, num_epochs, step_size_0, x0)
% pslGD: Performs gradient descent on the inference problem defined by the 
%  provided potentials. Note that this implementation assumes that the 
%  [0,1] box constraints are the only constraints of the problem.

    % Store iterates.
    x = zeros(num_epochs, length(x0));
    x(1, :) = x0;

    % Initialize objective and gradients.
    objectives = zeros(num_epochs, 1);
    gradients = zeros(num_epochs, length(x0));

    % Loop for num_epochs.
    for i=1: num_epochs
        step_size = step_size_0 / i;
        % compute objective and gradient.
        [objectives(i), gradients(i, :)] = parallelComputeObjectiveAndGradient(potentials, x(i, :));
        % GD step.
        x(i + 1, :) = x(i, :).' - step_size * gradients(i, :).';
        % Clip for box constraints.
        x(i + 1, :) = min(max(min(x(i + 1, :), 1), 0), 1);
    end 
end

