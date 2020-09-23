function [cell] = ur_norm(cell)


for i = 1:size(cell,2)
    ur_pk = [];
    ur_pk1 = []; %ur peak of each CR_trial
    %down sample to 300 data points for CR trace
    for j= 1:size(cell(i).ttt.tss_CR,2)
        new = [];
    for k = 1:300
        n = (k-1)*100+1;
        all = cell(i).ttt.tss_CR(j).blk(n:(100*k));
        all = mean(all);
        new = [new,all];
    end
    cell(i).ttt.tss_CR(j).blk = new;
    ur_pk1 = [ur_pk1,max(new(150:170))];
    end
    
    ur_pk0 = []; %ur peak of each Non_CR_trial
    %down sample to 300 data points non_CR trace
    for j= 1:size(cell(i).ttt.tss_NO_CR,2)
        new = [];
    for k = 1:300
        n = (k-1)*100+1;
        all = cell(i).ttt.tss_NO_CR(j).blk(n:(100*k));
        all = mean(all);
        new = [new,all];
    end
    cell(i).ttt.tss_NO_CR(j).blk = new;
    ur_pk0 = [ur_pk0,max(new(150:170))];
    end
    ur_pk = [ur_pk1,ur_pk0];
    ur_avr = mean(ur_pk);
    
    %nomalize each trial to average UR peak (ur_avr)
    for j= 1:size(cell(i).ttt.tss_CR,2)
        cell(i).ttt.tss_CR(j).blk = [cell(i).ttt.tss_CR(j).blk]/ur_avr*100;
    end
    for j= 1:size(cell(i).ttt.tss_NO_CR,2)
        cell(i).ttt.tss_NO_CR(j).blk = [cell(i).ttt.tss_NO_CR(j).blk]/ur_avr*100;
    end
    
end

end

