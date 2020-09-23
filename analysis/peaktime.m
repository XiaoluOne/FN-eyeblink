function [cell] = peaktime(cell)

%find peak time, peak value, onset base on psth with 10ms bin size (no sliding)

for i = 1:size(cell,2)
    %find CR peak(%UR), CR peak time,UR peak time
    cell(i).CR_on = round(mean([cell(i).SS_ttt.tss_CR(1:size(cell(i).SS_ttt.tss_CR,2)).CR_on]));
    cell(i).CR_pk = round(mean([cell(i).SS_ttt.tss_CR(1:size(cell(i).SS_ttt.tss_CR,2)).CR_pk]));
    cell(i).CR_pkt = round(mean([cell(i).SS_ttt.tss_CR(1:size(cell(i).SS_ttt.tss_CR,2)).CR_pkt]));
    cell(i).UR_pkt = round(mean([cell(i).SS_ttt.tss_CR(1:size(cell(i).SS_ttt.tss_CR,2)).UR_pkt]));
    
    %find cs-modulation extreme value (peak or trough)
    spk_new = smooth([cell(i).spk.CR_psth(1:150).h]);
    bsl = spk_new(1:50);
    bsl_std = std(bsl);
    bsl_mean = mean(bsl);
    if isequal(cell(i).CSC_mod, 'FAC') 
        cell(i).mod_on = 10*find( spk_new(51:75)> bsl_mean+3*bsl_std,1);
        [cmod_pk, cmod_pkt] = max(spk_new(51:75)); %[500:625] for complex spike, [500:740] for simple spike
        cell(i).cmod_pkt = cmod_pkt*10; %remember plus (x-500)
    elseif isequal(cell(i).CSC_mod, 'SUP')
        cell(i).mod_on = 10*find( spk_new(51:75)< bsl_mean-3*bsl_std,1);
        [cmod_pk, cmod_pkt] = min(spk_new(51:75)); %[500:625] for complex spike, [500:740] for simple spike
        cell(i).cmod_pkt = cmod_pkt*10; 
    else
        cell(i).mod_on = [];
        cell(i).cmod_pkt = [];
    end
    
    %find us-modulation extreme value (peak or trough)
    if isequal(cell(i).CSU_mod, 'FAC')
        [umod_pk, umod_pkt] = max(spk_new(75:85)); %[750:870] for complex spike
        cell(i).umod_pkt = umod_pkt*10+250;
    else
        [umod_pk, umod_pkt] = min(spk_new(75:85)); %[750:870] for complex spike
        cell(i).umod_pkt = []; %umod_pkt*10+250; 
    end
    
end


end

