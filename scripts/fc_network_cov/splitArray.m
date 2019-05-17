function splited = splitArray(array, numOfGroups)

    len = length(array);
    elementsInGroup = floor(len/numOfGroups);
    conf = elementsInGroup*ones(numOfGroups,1); % create dimensions conf for mat2cell
    conf(end) = conf(end) + mod(len,numOfGroups);
    %conf
    splited=mat2cell(array,1,conf);
end
