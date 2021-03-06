
path_general='/Users/yoav.feldman/ML/final-project/scripts/env_corr/';
path_data='/Users/yoav.feldman/ML/final-project/scripts/data/';
path_subjects = [path_data '2mm'];
path_avg_mat = [path_data 'avg'];
path_inner = 'MNINonLinear/Results/tfMRI_MOVIE1_7T_AP/tfMRI_MOVIE1_7T_AP_Atlas_MSMAll_hp2000_clean.dtseries.nii';
path_wb_command = '/Applications/workbench/bin_macosx64/wb_command';
th = 0;

[x, fs] = audioread('/Users/yoav.feldman/ML/hcp/7T_MOVIE1_CC1.mp4');
audio = x(:,1);

[envU, ~] = envelope(audio, 3e5, 'rms'); % - max corr 0.51
%[envU, ~] = envelope(audio, 3e5, 'peak'); % - max corr 0.46
%[envU, ~] = envelope(audio, fs, 'rms'); % - max corr 0.32
%[envU, ~] = envelope(audio, fs, 'peak'); % - max corr 0.28
%envU = abs(hilbert(audio)) % - max corr 0.30;


env = downsample(envU, fs); %downsample the audio to 1hz

%plot(audio,'r')
%hold on
%plot(envU,'g')
%figure(2)
%plot(env,'b')

sub_names=dir(path_subjects);
sub_vec = {sub_names(3:(end),1).name};
n = length(sub_vec);
%n =2; %debug׳

tic

for i=1:n
    %load subject file
    sub_file_path = fullfile(path_subjects,sub_vec(i), path_inner);
    sub_file = ciftiopen(string(sub_file_path),path_wb_command);

    if i==1
        avg = zeros(size(sub_file.cdata));
    end
    avg = avg + sub_file.cdata;
end
avg = avg./n;

parts_start_tr = [20,284,525,735,818];
parts_end_tr = [264,505,715,798,901];

for part=1:length(parts_end_tr)
    startTR = parts_start_tr(part);
    endTR = parts_end_tr(part);
    
    %calc corr
    norm_avg = zscore(avg(:,startTR:endTR)');
    norm_env = zscore(env(startTR:endTR));
    samples = endTR-startTR;
    corr = (1/(samples-1))*sum(norm_avg.*norm_env);
    
    % th
    mask = abs(corr)>th;
    corr(:,~mask) = NaN;
    
    max(corr)
    nii_file = sub_file;
    nii_file.cdata = corr';
    %res_file_path = strcat(path_general, 'res_', num2str(part), '.dtseries.nii');
    %ciftisavereset(nii_file, res_file_path ,path_wb_command);
end
