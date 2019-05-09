
function net = get_net_parcells(net_idx)
    net_map_file = 'cortex_subcortex_parcel_network_assignments.txt';
    net = [];
    fid = fopen(net_map_file);
    line = 1;
    
    while ~feof(fid)
        p = fgetl(fid);
        if p == string(net_idx) || net_idx == -1 %-1 = all brain
            net = [net,line];
        end
        line = line + 1;
    end
end