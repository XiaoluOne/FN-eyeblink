function [cell] = umod(cell)
%detect US modulation type based on 1500 trace 
for i = 1:size(cell,2)
    spk_new = [];
    for j = 1:1500 %shorten trace to 1500
        n = (j-1)*20+1;
        spk_all = mean(cell(i).spk.CR_trace(n:(20*j)));
        spk_new = [spk_new,spk_all];
    end
    spk_new = smooth(spk_new);
    %judge US modulation type
    bsl = spk_new(1:500);
    bsl_mean = mean(bsl);
    if mean(spk_new(750:850))-bsl_mean > 5 %[750:800]threshold 1 for complex spike; 5 for simple spike   
            cell(i).umod = 'FAC';
    elseif mean(spk_new(750:850))-bsl_mean < -5 %comment for complex spike
            cell(i).umod = 'SUP';
    else
            cell(i).umod = 'NOM';
    end
end

end

