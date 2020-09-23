function [ cell ] = ur_sliding(cell)
%cell is the struct that will be processed
%w is windowsize 
%s is sliding step
for i = 1:size(cell,2)
    %shorten blk trace to 1500
    blk_new = [];
    for j = 1:1500
         n = (j-1)*20+1;
        blk_all = mean(cell(i).blk(1).tr(n:(20*j)));
        blk_new = [blk_new,blk_all];
    end
    blk_new = smooth(blk_new);

    %sliding 50 window, 1 step    
    blk = [];
    n=0;
    for k = 1:1449
        a = mean(blk_new(k:(50+k)));
        n = n+1;
        blk(n) = a;
    end
    cell(i).blk_sliding = blk;
end

