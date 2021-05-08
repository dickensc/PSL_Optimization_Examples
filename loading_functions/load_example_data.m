function [hinge_potentials, square_hinge_potentials, ...
    linear_potentials, quadratic_potentials, ...
    constraints, meta_data] = load_example_data(example_name)
    % Load problem data to formulate inference problem. 
    example_directory = sprintf("./%s", example_name);
    
    % Load hinge potentials.
    hinge_potentials_file = sprintf("%s/hinge_potentials.tsv", example_directory);
    hinge_potentials = load_potential_file(hinge_potentials_file);
    
    % Load square hinge potentials.
    square_hinge_potentials_file = sprintf("%s/square_hinge_potentials.tsv", example_directory);
    square_hinge_potentials = load_potential_file(square_hinge_potentials_file);
    
    % Load linear potentials.
    linear_potentials_file = sprintf("%s/linear_potentials.tsv", example_directory);
    linear_potentials = load_potential_file(linear_potentials_file);
    
    % Load quadratic potentials.
    quadratic_potentials_file = sprintf("%s/quadratic_potentials.tsv", example_directory);
    quadratic_potentials = load_potential_file(quadratic_potentials_file);
    
    % Load constraints.
    constraint_file = sprintf("%s/constraints.tsv", example_directory);
    constraints = load_constraint_file(constraint_file);
    
    % Load problem meta-data.
    meta_data_file = sprintf("%s/meta_data.tsv", example_directory);
    meta_data = load_meta_data(meta_data_file);
end

