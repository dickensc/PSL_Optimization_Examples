function [x, objectives, gradients] = pslNaiveCD(potentials, num_epochs, step_size, x0)
% pslCD: Performs coordinate descent on inference problems defined with the 
%  provided potentials. Note that this implementation assumes that the 
%  [0,1] box constraints are the only constraints of the problem.

    % Store iterates.
    x = zeros(num_epochs, length(x0));
    x(1, :) = x0;

    % Initialize objective and gradients.
    objectives = zeros(num_epochs, 1);
    gradients = zeros(num_epochs * length(x0), length(x0));

    % gradients index
    k = 1;
    
    % Loop for num_epochs.
    for i=1: num_epochs
        for j=1: length(x0)
            % compute gradient.
            gradients(i, :) = computeNonSmoothGradient(potentials, x(i, :));
            % CD step.
            x(i + 1, :) = x(i, :).' - step_size * gradients(i, :).';
            % Clip for box constraints.
            x(i + 1, :) = min(max(min(x(i + 1, :), 1), 0), 1);
    end
end

