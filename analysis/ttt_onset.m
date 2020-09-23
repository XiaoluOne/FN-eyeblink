function [cell] = ttt_onset(cell)

%find CR onset for each cell in CS_ttt array (300 data points) 
for i = 1:size(cell,2)
    for j = 1:size(cell(i).CS_ttt.tss_CR,2)
       bsl = cell(i).CS_ttt.tss_CR(j).blk(1:100);
       bsl_std = std(bsl);
       bsl_mean = mean(bsl);
       idx = find(cell(i).CS_ttt.tss_CR(j).blk(110:149)> bsl_mean + 6*bsl_std,1);
       cell(i).CS_ttt.tss_CR(j).CR_on = (idx+10)*5;
       if ~isempty(cell(i).CS_ttt.tss_CR(j).CR_on)
           [cell(i).CS_ttt.tss_CR(j).CR_pk,CR_pkt] = max(cell(i).CS_ttt.tss_CR(j).blk(110:150));
           cell(i).CS_ttt.tss_CR(j).CR_pkt = (CR_pkt+9)*5;
       else
           cell(i).CS_ttt.tss_CR(j).CR_pk = [];
           cell(i).CS_ttt.tss_CR(j).CR_pkt = [];
       end
       [cell(i).CS_ttt.tss_CR(j).UR_pk,UR_pkt] = max(cell(i).CS_ttt.tss_CR(j).blk(151:170));
       cell(i).CS_ttt.tss_CR(j).UR_pkt = (UR_pkt+49)*5;
    end
end
end

