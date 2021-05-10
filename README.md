# PSL_Optimization_Examples
This repository contains example PSL inference optimization problems.
Potential functions and constraints defining the inference problem were exported during a run of selected [PSL examples](https://github.com/linqs/psl-examples).
Matlab scripts are provided for loading the exported potential functions.
Additionally there are examples scripts for optimizing over non-smooth and smooth problem formulations.

## Potential and Constraint data file formats.
Currently the examples provided are lastfm, epinions, entity-resolution, and cora.
Every PSL example has its own directory identifiable by the example name. 

### meta_data.tsv
Every example contains a meta_data.tsv file, example: lastfm/meta_data.tsv
This file currently only contains the number of decision variables in the non-smooth formulation of the inference problem.

## Potential files
An example can contain up to one of each of the following files: 
hinge_potentials.tsv, square_hinge_potentials.tsv, linear_potentials.tsv, quadratic_potentials.tsv

These files all share the same format:
```Weight	Var_Index	Var_Coefficient	Constant```
