function [tr] = seven_shorten(tr,before,after)
%------------this function if for shortening traces---------------
%tr is raw shace, could be blk or spk
%before is data point before shortening
%after is data point after shortening

    new = [];
    for j = 1:after
        z = before/after;
        n = (j-1)*z+1;
        new = [new,mean(tr(n:(z*j)))]; 
    end
    new = smooth(new);
    tr = new;
end

