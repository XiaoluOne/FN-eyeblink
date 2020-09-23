
%FN lesion analysis
CR_pk = [];
for i = 1:size(blk,2)
    if isequal(blk(i).type,'CS_only') 
        CR_pk = [CR_pk,blk(i).CR_pk];
    end
end
avr_pk = mean(CR_pk);
CR0 = find(CR_pk == 0);
CR1 = size(CR_pk,2)-size(CR0,2);
CR_ratio = CR1/size(CR_pk,2)*100;



%for plotting
paired = [];
cs_only = [];
for i = 1:size(blk,2)
    if isequal(blk(i).type,'paired')
        paired = [paired,blk(i).tr];
    elseif isequal(blk(i).type,'CS_only')
        cs_only = [cs_only,blk(i).tr];
    else
    end
end

avr_paired = mean(paired');
avr_cs_only = mean(cs_only');
% plot(smooth(avr_paired))
hold on
plot(smooth(avr_cs_only))