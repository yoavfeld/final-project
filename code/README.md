# Final Project Code

## Folders

- connectivity/ - many scripts to calculate brain connectivities (FC, ISC, ISFC)

- fc_network_cov/ - calculate fc corellations matrix for twin prediction algorithm

- lib/ - framework scripts used by all the other code

- parcellate/ - hcp data parcellation script + info

- twin_pred/ - twins prediction by resting stat scans

- fluid_intelligence_pred/ - fluid intelligence prediction by movie watching scans

## Prerequisites
 - HCP workbench (wb_command) -  https://www.humanconnectome.org/software/get-connectome-workbench
 - GIFTI matlab lib - https://www.artefact.tk/software/matlab/gifti/ - add to matlab search path 
 - HCP CIFTI matlab functions (only ciftiopen.m, ciftisave.m, ciftisavereset.m - add to matlab search path) - https://github.com/Washington-University/HCPpipelines/tree/master/global/matlab 
- add final-project/code/lib folder to matlab search path
