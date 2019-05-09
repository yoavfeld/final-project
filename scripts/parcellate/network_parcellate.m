wb_command = '/Applications/workbench/bin_macosx64/wb_command';
data_path = [pwd, '/../data'];
path_subjects = [data_path '/2mm'];
path_avg_mat = [data_path '/avg'];
path_inner = 'MNINonLinear/Results/tfMRI_MOVIE1_7T_AP/tfMRI_MOVIE1_7T_AP_Atlas_MSMAll_hp2000_clean.dtseries.nii';
output_dir = 'output';

%Setting the parcel files to be the 718 parcels (cortical + subcortical)
parcelCIFTIFile='CortexSubcortex_ColeAnticevic_NetPartition_wSubcorGSR_netassignments_LR.dlabel.nii';

sub_names=dir(path_subjects);
sub_vec = {sub_names(3:(end),1).name};
n = length(sub_vec);
%n =2; %debug
for i=1:n
    subjectCifti = fullfile(path_subjects,sub_vec{i}, path_inner);
    parcelTSFilename=[output_dir '/' sub_vec{i} '_Output_Atlas_CortSubcort.Network.LR.ptseries.nii'];
    eval(['!' wb_command ' -cifti-parcellate ' subjectCifti ' ' parcelCIFTIFile ' COLUMN ' parcelTSFilename ' -method MEAN'])
end
