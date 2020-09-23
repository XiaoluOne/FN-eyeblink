% Verify stimulation locations by behavior identifier, designed to be processed before PSTH.
% (c) Si-yang Yu @ PSI 2018

% Function input:  on,     defined as a logical, 1 means use identifier / 0 means keep all
%                  loc_in, input of original stimulation locations, 1D-array
%                  id_vfy, input of identifiers, 1D-cell_array, [] means delete / else means keep
% Function output: locs,   defined as an array of struct (2 fields, defined below)
%                            nr: the trial number
%                            t:  the tirgger timing

function locs = locs_vfy(on,loc_in,id_vfy)
    on = logical(on);
    if on
        i = 1;
        n = 1;
        while i <= size(loc_in,1)
            if ~isempty(id_vfy{i})
                locs(n).nr = i;
                locs(n).t = loc_in(i);
                n = n + 1;
            end
            i = i + 1;
        end
    else
        n = 1;
        while n <= size(loc_in,1)
            locs(n).nr = n;
            locs(n).t = loc_in(n);
            n = n + 1;
        end
    end
end