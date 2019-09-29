classdef Labels
   properties
      data
      subIds
   end
   methods
       %Ctor for labels
       function obj = Labels(lablesFile, subIdsFile, labelsData)
           if exist('lablesFile', 'var') && ~isempty(lablesFile)
               obj.data = load_restricted(lablesFile);
           elseif exist('labelsData', 'var') && ~isempty(labelsData)
               obj.data = labelsData;
           end
           if exist('subIdsFile','var') && ~isempty(subIdsFile)
               obj.subIds = importdata(subIdsFile);
           end
       end
       % read label by subject index. (0-182)
       % TODO: use read_label_by_id
       function [value, exist] = read_labels(obj, subject_idx, column)
           subject_id = obj.subIds(subject_idx);
           %subject_id = obj.subIds(randi(length(obj.subIds))); % for random test only
           data = obj.data;
           row = data(data.Subject == subject_id, :);
           if size(row,1) == 0
               value = 0;
               exist = 0;
               return
           end
           value = row(:,{column});
           exist = 1;
       end
       % read label by subject id. ex: 100106
       function [value, exist] = read_label_by_id(obj, subject_id, column)
           data = obj.data;
           row = data(data.Subject == subject_id, :);
           if size(row,1) == 0
               value = 0;
               exist = 0;
               return
           end
           value = row(:,{column});
           exist = 1;
       end
       function [diff] = zygosityDIFF(obj, subject_idx)
           [sr, exist] = obj.read_labels( subject_idx, 'ZygositySR');
           [gt, exist] = obj.read_labels( subject_idx, 'ZygosityGT');
           if ~isundefined(gt{1,1}) && gt{1,1} ~= 'DZ' && sr{1,1} ~= gt{1,1}
               %obj.subIds(subject_idx)
               diff = 1;
               return
           end
           diff =0; 
       end
       function [zygocity, exist] = zygosity(obj, subject_idx)
           [v, exist] = obj.read_labels( subject_idx, 'ZygosityGT');
           if ~exist
               zygocity = '';
               return
           end
           zygocity = v{1,1};
           if ~isundefined(zygocity)
               return
           end
           %obj.subIds(subject_idx)
           [v, e] = obj.read_labels( subject_idx, 'ZygositySR');
           if ~exist
               zygocity = '';
               return
           end
           zygocity = v{1,1};               
       end
       function [familyID, exist] = family(obj, subject_idx)
           [v, exist] = obj.read_labels( subject_idx, 'Family_ID');
           if ~exist
               familyID = 0;
               return
           end
           familyID = v{1,1};
       end
       function [value, exist] = fluidIntelligence(obj, subject_id)
           [v, exist] = obj.read_label_by_id(subject_id, 'PMAT24_A_CR');
           if ~exist
               value = 0;
               return
           end
           value = v{1,1};
       end
       
   end
end
