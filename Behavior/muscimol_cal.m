function [ blk ] = muscimol_cal(blk)
%calculate mean UR peak of all trials in on experiment (ur_pk_avr)
ur_pk = [];
for i = 1:size(blk,2)
    if isequal(blk(i).type,'paired')
        ur_pk = [ur_pk;blk(i).ur_amp];
    else
    end
end
ur_pk_avr = mean(ur_pk);

%nomalize eye lid trace to ur_pk_avr
for i = 1:size(blk,2)
    blk(i).tr = blk(i).tr/ur_pk_avr*100;
end

%normalize UR peak and CR peak to ur_pk_avr
for i = 1:size(blk,2)
    if isequal(blk(i).type,'paired') 
        blk(i).UR_pk = blk(i).ur_amp/ur_pk_avr*100;
        blk(i).CR_pk = blk(i).cr_amp/ur_pk_avr*100;
        [u,u_idx] = max(blk(i).tr(751:850));%UR half-peak width calculation
        w_first = find(blk(i).tr(750:(u_idx+750))>=round(u/2),1); 
        w_last = find(blk(i).tr((u_idx+750):1500)>=round(u/2),1);
        blk(i).UR_hw = w_last+u_idx-w_first;
    else
        blk(i).CR_pk = blk(i).cr_amp/ur_pk_avr*100;
    end
end


end

