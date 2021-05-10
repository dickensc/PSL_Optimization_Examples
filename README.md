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

### Constraint file
An example can contain up to one `constraints.tsv` file

This has the format:
```
Var_Index	Var_Coefficient	Constant
```
`Var_Index` is the decision variable indices that are involved in the constraint.
`Var_Coefficient` is the decision variable coefficients defining the constraint.
`Constant` is the constant term defining the constraint.

## Loading Functions
Loading functions is a directory that contains files defining Matlab functions for loading the .tsv formatted potential and contstraint files.
`load_meta_data.m` will load a meta_data.tsv file and return a table with column `Num_Variables`.
`load_potential_file.m` will load a potential file and return a table with columns `Weight`, `Var_Index`, `Var_Coefficient`, and `Constant`.
`load_coonstraint_file.m` will load a constraint file and return a table with columns `Var_Index`, `Var_Coefficient`, and `Constant`.
`load_example_data.m` will load the meta_data.tsv and all existing potential and constraint files in a specified example directory and return appropriate tables for each.

## Non Smooth Helpers
non_smooth_helpers is a directory containing files defining Matlab functions for evaluating the non smooth problem objective and the gradient of a potential.
`evaluateNonSmoothObjective.m` will evaluate the non_smooth objective given a table of potentials with columns: `Weight`, `Var_Index`, `Var_Coefficient`, `Constant`, `hinge`, `square`. `hinge` and `square` are boolean valued columns indiciating whether the potential is a hinge potential and it is squared.
`computeNonSmoothPotentialGradient.m` will compute the gradient of a provided potential at a specified location.

## Smooth Helpers
smooth_helpers is a directory containg files that help formulate the smooth inference problem.
`get_qp_problem.m` will return the parameters defining a linearly constrained quadratic program from the provided potential and constraint tables. The returned parameters define the quadratic program

```
min_{x} x^T H x + f^T x
s.t. Ax \leq b
```
