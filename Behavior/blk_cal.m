function [blk] = blk_cal(blk)

%shorten eyeblink trace from 50k to 1500 points (-500 to 1000ms) 
for i = 1:size(blk,2)
    blk(i).tr = blk(i).tr(1:30000);
    new = [];
    for j = 1:1500
        n = (j-1)*20+1;
        new = [new,mean(blk(i).tr(n:(20*j)))]; 
    end
    new = smooth(new);
    blk(i).tr = new;
end

%calculat mean UR as standard
ur = [];
for i = 1:size(blk,2)
    if ~isequal(blk(i).type,'CS_only') 
        ur = [ur;max(blk(i).tr(751:850))];
    else end
end
ur_avr = mean(ur);

% normalize eyeblink trace to mean UR
for i = 1:size(blk,2)
    blk(i).tr = blk(i).tr/ur_avr*100;
end

%find CR onset, CR peak, CR peaktime, UR peak, UR peaktime, UR
%half-peak width
for i = 1:size(blk,2)
   base_sd = std(blk(i).tr(1:500));
   base_mean = mean(blk(i).tr(1:500));
   if ~isequal(blk(i).type,'CS_only')
       %UR info (nom-CS-only trials)
       [u,u_idx] = max(blk(i).tr(751:850));
       blk(i).UR_pk = u;
       blk(i).UR_pkt = u_idx + 250;
       w_first = find(blk(i).tr(750:(u_idx+750))>=round(u/2),1); %UR half-peak width calculation
       w_last = find(blk(i).tr((u_idx+750):1500)>=round(u/2),1);
       blk(i).UR_hw = w_last+u_idx-w_first;
       %CR INFO (nom-CS-only trials)
       on_idx = find(blk(i).tr(500:749)> base_mean+6*base_sd,1);
       if ~isempty(on_idx)
           blk(i).CR_ON = on_idx;
           [m,m_idx] = max(blk(i).tr(on_idx+500:749)); 
           blk(i).CR_pk = m;
           blk(i).CR_pkt = m_idx + on_idx;
       else
           blk(i).CR_ON = 0;
           blk(i).CR_pk = 0;
           blk(i).CR_pkt = 0;
       end
   else
       %UR info (CS-only trials)
       blk(i).UR_pk = [];
       blk(i).UR_pkt = [];
       blk(i).UR_hw = [];
       %CR INFO (CS-only trials)
       on_idx = find(blk(i).tr(500:850)> base_mean+6*base_sd,1);
       if ~isempty(on_idx)
           blk(i).CR_ON = on_idx;
           [m,m_idx] = max(blk(i).tr(on_idx+500:850)); 
           blk(i).CR_pk = m;
           blk(i).CR_pkt = m_idx + on_idx;
       else
           blk(i).CR_ON = 0;
           blk(i).CR_pk = 0;
           blk(i).CR_pkt = 0;
       end
   end
end

end

