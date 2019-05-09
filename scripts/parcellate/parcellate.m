
wb_command = '/Applications/workbench/bin_macosx64/wb_command';
data_path = ['/Volumes/TOSHIBA_EXT/hcp/7T_Movie'];
path_inner = 'MNINonLinear/Results/tfMRI_MOVIE1_7T_AP/tfMRI_MOVIE1_7T_AP_Atlas_MSMAll_hp2000_clean.dtseries.nii';
output_dir = 'movie_parcellated';

%Setting the parcel files to be the 718 parcels (cortical + subcortical)
parcelCIFTIFile='CortexSubcortex_ColeAnticevic_NetPartition_wSubcorGSR_parcels_LR.dlabel.nii';

sub_names=dir(data_path);
sub_vec = {sub_names(3:(end),1).name};
n = length(sub_vec);
%n =2; %debug
for i=1:n
    subjectCifti = fullfile(data_path,sub_vec{i}, path_inner);
    parcelTSFilename=[output_dir '/' sub_vec{i} '_Output_Atlas_CortSubcort_Movie1.Parcels.LR.ptseries.nii'];
    eval(['!' wb_command ' -cifti-parcellate ' subjectCifti ' ' parcelCIFTIFile ' COLUMN ' parcelTSFilename ' -method MEAN'])
end
