
wb_command = '/Applications/workbench/bin_macosx64/wb_command';
data_path = ['/Volumes/7T_data/7T_rest/'];
path_inner = 'MNINonLinear/Results/rfMRI_REST2_7T_AP/rfMRI_REST2_7T_AP_Atlas_MSMAll_hp2000_clean.dtseries.nii';
output_dir = 'data/7T_rest2_181';
output_file_suffix = '_Output_Atlas_CortSubcort_7T_Rest2.Parcels.AP.ptseries.nii';

%Setting the parcel files to be the 718 parcels (cortical + subcortical)
parcelCIFTIFile='CortexSubcortex_ColeAnticevic_NetPartition_wSubcorGSR_parcels_LR.dlabel.nii';

sub_names=dir(data_path);
sub_vec = {sub_names(3:(end),1).name};
n = length(sub_vec);
sub_blacklist = {'473952','995174', '745555', '126931' , '181636', '536647', '552241', '585256', '973770',  '111312'};
%n =2; %debug
for i=1:n
    if ismember(sub_vec{i}, sub_blacklist)
        fprintf("skip subject %s \n", sub_vec{i});
        %continue
    end
    subjectCifti = fullfile(data_path,sub_vec{i}, path_inner);
    parcelTSFilename=[output_dir '/' sub_vec{i} output_file_suffix];
    eval(['!' wb_command ' -cifti-parcellate ' subjectCifti ' ' parcelCIFTIFile ' COLUMN ' parcelTSFilename ' -method MEAN'])
end
