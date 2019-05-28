classdef Labels
   properties
      data
      subIds
   end
   methods
       function obj = Labels(lablesFile, subIdsFile)
           obj.data = load_restricted(lablesFile);
           obj.subIds = importdata(subIdsFile);
       end
       function [value, exist] = read_labels(obj, subject_idx, column)
           subject_id = obj.subIds(subject_idx);
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
       function [zygocity, exist] = zygosity(obj, subject_idx)
           [v, exist] = obj.read_labels( subject_idx, 'ZygositySR');
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
   end
end
