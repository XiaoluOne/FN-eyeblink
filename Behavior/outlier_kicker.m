%outlinear kicker
for i = 1:size(blk,2)
    if  blk(i).CR_ON>246 || blk(i).CR_pk < 5 || blk(i).CR_ON < 50
        blk(i).CR_ON = 0;
        blk(i).CR_pk = 0;
        blk(i).CR_pkt = 0;
    else 
    end
end
