function [cell] = onset(cell)

%find CR onset for each cell in ttt array 
for i = 1:size(cell,2)
    for j = 1:size(cell(i).ttt.tss_CR,2)
       bsl = cell(i).ttt.tss_CR(j).blk(1:100);
       bsl_std = std(bsl);
       bsl_mean = mean(bsl);
       idx = find(cell(i).ttt.tss_CR(j).blk(110:149)> bsl_mean+6*bsl_std,1);
       cell(i).ttt(j).CR_on = (idx+10)*5;
    end
end
end

