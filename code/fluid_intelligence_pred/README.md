# General
This folder contains code for fluid intelligence prediction by movie-task fMRI scans.

Scripts in this folder, is running on 718x900 data that was parcelated by [parcellate script](/code/parcellate/parcellate.m)

# Entry points:

## Preprocessing
- fc_parts.m - Create FC matrices per movie part per network
- isfc_parts.m - Create ISFC matrices per movie part per network
- prepare_XY.m - Prepare X and Y matrices (for ML model) for each network, by FC or ISFC matrices.

## Running PLS model
- pls_compare.m - Run pls (train and perform predictions) per network per movie part and plot the results.
- pls_cross_movies.m - Run pls all parts of all movies (4 movies) and plot the results.
- random_Y.m - Run pls per specific network per movie part, with shuffled permutations of Y vector, and plot the results.

## Connectivity maps
- isc_parts.m - Create ISC maps (cifti files) per movie part.
- isfc_seed.m - Create seed based ISFC maps (cifti files) per movie part.


