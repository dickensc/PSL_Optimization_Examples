function [H, f, A, b, Aeq, beq, lb, ub] = get_qp_problem(hinge_potentials, ...
    square_hinge_potentials, linear_potentials, quadratic_potentials, ...
    constraints, meta_data)
    % Formulate Quadratic Program.
    smooth_num_variables = meta_data.Num_Variables + height(square_hinge_potentials) + height(hinge_potentials);

    % Quadratic Potentials.
    Q_Q = sparse(height(quadratic_potentials), smooth_num_variables);
    b_Q = sparse(smooth_num_variables, 1);
    for i = 1: height(quadratic_potentials)
        var_indices = quadratic_potentials.Var_Index{i}{1};
        var_coefficients = quadratic_potentials.Var_Coefficient{i}{1};
        constant = quadratic_potentials.Constant(i);
        weight = quadratic_potentials.Weight(i);


        Q_Q(var_indices, var_indices) = Q_Q(var_indices, var_indices) + weight * (var_coefficients * var_coefficients'); 
        b_Q(var_indices) = b_Q(var_indices) - 2 * weight * constant * var_coefficients;
    end

    % Linear Potentials.
    b_L = sparse(smooth_num_variables, 1);
    for i = 1: height(linear_potentials)
        var_indices = linear_potentials.Var_Index{i}{1};
        var_coefficients = linear_potentials.Var_Coefficient{i}{1};
        constant = linear_potentials.Constant(i);
        weight = linear_potentials.Weight(i);

        b_L(var_indices) = b_L(var_indices) + weight * var_coefficients;
    end

    % Square Hinge Potentials.
    Q_SH = sparse(height(square_hinge_potentials), smooth_num_variables);
    A_SH = sparse(height(square_hinge_potentials), smooth_num_variables);
    c_SH = sparse(height(square_hinge_potentials), 1);
    for i = 1: height(square_hinge_potentials)
        var_indices = square_hinge_potentials.Var_Index{i}{1};
        var_coefficients = square_hinge_potentials.Var_Coefficient{i}{1};
        constant = square_hinge_potentials.Constant(i);
        weight = square_hinge_potentials.Weight(i);

        Q_SH(i, meta_data.Num_Variables + i) = weight;
        A_SH(i, var_indices) = var_coefficients;
        A_SH(i, meta_data.Num_Variables + i) = -1;
        c_SH(i) = constant;
    end

    % Linear Hinge Potentials.
    b_H = sparse(smooth_num_variables, 1);
    A_H = sparse(height(hinge_potentials), smooth_num_variables);
    c_H = sparse(height(hinge_potentials), 1);
    for i = 1: height(hinge_potentials)
        var_indices = hinge_potentials.Var_Index{i}{1};
        var_coefficients = hinge_potentials.Var_Coefficient{i}{1};
        constant = hinge_potentials.Constant(i);
        weight = hinge_potentials.Weight(i);

        b_H(meta_data.Num_Variables + height(square_hinge_potentials) + i) = weight;
        A_H(i, var_indices) = var_coefficients;
        A_H(i, meta_data.Num_Variables + height(square_hinge_potentials) + i) = -1;
        c_H(i) = constant;
    end

    % Constraints.
    A_C = sparse(height(constraints), smooth_num_variables);
    c_C = sparse(height(constraints), 1);
    for i = 1: height(constraints)
        var_indices = constraints.Var_Index{i}{1};
        var_coefficients = constraints.Var_Coefficient{i}{1};
        constant = constraints.Constant(i);

        A_C(i, var_indices) = var_coefficients;
        c_C(i) = constant;
    end

    % Box constraints on x.
    A_box = sparse(meta_data.Num_Variables * 2, smooth_num_variables);
    c_box = [ones(meta_data.Num_Variables, 1); zeros(meta_data.Num_Variables, 1)];
    for i = 1: (meta_data.Num_Variables)
        A_box(i, i) = 1;
        A_box(i + meta_data.Num_Variables, i) = -1;
    end

    % Slack Potentials.
    A_slack = sparse(height(hinge_potentials) + height(square_hinge_potentials), smooth_num_variables);
    c_slack = zeros((height(hinge_potentials) + height(square_hinge_potentials)), 1);
    for i = 1: (height(hinge_potentials) + height(square_hinge_potentials))
        A_slack(i, meta_data.Num_Variables + i) = -1;
    end

    % Define QP.
    H = [Q_Q;Q_SH];
    f = b_Q + b_L + b_H;
    A = [A_SH; A_H; A_C; A_box; A_slack];
    b = [c_SH; c_H; c_C; c_box; c_slack];
    Aeq = [];
    beq = [];
    lb = [];
    ub = [];
end

