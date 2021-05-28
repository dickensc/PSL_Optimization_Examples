# PSL_Optimization_Examples
This repository contains example PSL inference optimization problems.
Potential functions and constraints defining the inference problem were exported during a run of selected [PSL examples](https://github.com/linqs/psl-examples).
Matlab scripts are provided for loading the exported potential functions.
Additionally there are examples scripts for optimizing over non-smooth and smooth problem formulations.

## Potential and Constraint data file formats.
Currently the examples provided are lastfm, epinions, entity-resolution, and cora.
Every PSL example has its own directory identifiable by the example name. 
In the direrctory of an example there are tab separated data files described below.

### meta_data.tsv
Every example contains a meta_data.tsv file, example: lastfm/meta_data.tsv
This file currently only contains the number of decision variables in the non-smooth formulation of the inference problem.

### Potential files
An example can contain up to one of each of the following files: 
hinge_potentials.tsv, square_hinge_potentials.tsv, linear_potentials.tsv, quadratic_potentials.tsv

These files all share the same format:
```
Weight	Var_Index	Var_Coefficient	Constant
```

`Weight` is the potential weight.

`Var_Index` is the decision variable indices that are involved in the potential. Each index is comma separated

`Var_Coefficient` is the decision variable coefficients defining the potential.

`Constant` is the constant term defining the potential.

### Constraint files
An example can contain up to one `constraints.tsv` file

This file has the format:
```
Var_Index	Var_Coefficient	Constant
```

`Var_Index` is the decision variable indices that are involved in the constraint.

`Var_Coefficient` is the decision variable coefficients defining the constraint.

`Constant` is the constant term defining the constraint.

## Loading Functions
loading_functions is a directory that contains files defining Matlab functions for loading the .tsv formatted potential and contstraint files.

`load_meta_data.m` will load a meta_data.tsv file and return a table with column `Num_Variables`.

`load_potential_file.m` will load a potential file and return a table with columns `Weight`, `Var_Index`, `Var_Coefficient`, and `Constant`.

`load_coonstraint_file.m` will load a constraint file and return a table with columns `Var_Index`, `Var_Coefficient`, and `Constant`.

`load_example_data.m` will load the meta_data.tsv and all existing potential and constraint files in a specified example directory and return appropriate tables for each.

## Non Smooth Helpers
non_smooth_helpers is a directory containing files defining Matlab functions for evaluating the non smooth problem objective and the gradient of a potential.

`evaluateNonSmoothObjective.m` will evaluate the non_smooth objective at a specified location: `x`, given a table of potentials with columns: `Weight`, `Var_Index`, `Var_Coefficient`, `Constant`, `hinge`, `square`. `hinge` and `square`.

`computeNonSmoothPotentialGradient.m` will compute the gradient of a provided potential at a specified location: `x`. The potential is defined with the parameters: `potential_indices`, `potential_coefficients`, `constant`, `weight`, `is_hinge`, `is_square`.

`computeNonSmoothGradient.m` will compute the gradient of an objective at a specified location: `x`. The objective is defined with a potential table as in `evaluateNonSmoothObjective.m`.

`computeObjectiveAndGradient` will compute the objective valuue and gradient of a problem defined by a table of potentials as in `evaluateNonSmoothObjective.m` at a  specified location: `x`.

## Smooth Helpers
smooth_helpers is a directory containg files that help formulate the smooth inference problem.

`get_qp_problem.m` will return the parameters defining a linearly constrained quadratic program from the provided potential and constraint tables. The returned parameters define the quadratic program

```
min_{x} x^T H x + f^T x
s.t. Ax \leq b
```

## Smooth Optimization Example
`smooth_psl_optimization_example.m` is an example script that will load example data using the helper in loading_functions, define a LCQP using `get_qp_problem.m` and then run Matlab's provdied QP solver `quadprog`.
To change the example that is used change the `example_name` variable at the top of the script. Example: `example_name = "lastfm";`

## Non Smooth Optimization Example
`non_smooth_psl_optimization_example.m` is an example script that will load example data using the helper in loading_functions, and then run both a simple implementation of SGD to minimize the non-smooth objective and use the MATLAB Non-linear Optimization Toolbox to define and solve a linearly constrained convex optimization problem.

To change the example that is used change the `example_name` variable at the top of the script. Example: `example_name = "lastfm";`
