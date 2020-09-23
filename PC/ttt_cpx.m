function [cell ] = ttt_cpx( cell )
        
%find onset of each trial
cell = ttt_onset(cell);

%exclude NON_CR trials and CS_only trials 
for i = 1:size(cell,2)
    idx = [];
    for j = 1:size(cell(i).CS_ttt.tss_CR,2)
        if isempty(cell(i).CS_ttt.tss_CR(j).CR_on) || isempty(cell(i).CS_ttt.tss_CR(j).t);
            idx = [idx;j];
        else
        end
    end
    cell(i).CS_ttt.tss_CR(idx) = [];
end        

for j = 1:size(cell,2)
            blk_t =[];
            spk_t =[];
            if isequal(cell(j).CSC_mod,'FAC') 
            for i = 1:size(cell(j).CS_ttt.tss_CR,2)
%        complex spk timing-blk onset correlation 
                             idx = find(cell(j).CS_ttt.tss_CR(i).t > 0,1);
                             if ~isempty(idx) && round(cell(j).CS_ttt.tss_CR(i).t(idx)*1000)<250
                                 spk_t = [spk_t;round(cell(j).CS_ttt.tss_CR(i).t(idx)*1000)];
                                 blk_t = [blk_t;cell(j).CS_ttt.tss_CR(i).CR_on];
                             else
                             end
            end
            
%        generate a table including spk(max/min), blk_max and trial number
         corr = table(spk_t(:,1),blk_t(:,1),'VariableNames',{'spk_t','blk_t'});

%        regression: mix-effect linear model (spk,trial and intercept are
%        fixed effects)
         reg = fitlm(corr,'blk_t~spk_t'); %if recording as random effect(1|recording)+(-1+spk|recording)
         reg_r = reg.Rsquared.Adjusted;
         reg_p = reg.Coefficients.pValue(2);
         reg_int = reg.Coefficients.Estimate(1);
         reg_slp = reg.Coefficients.Estimate(2);
         %Organize outputs in cell struct
         cell(j).corr = corr;
         cell(j).reg_r = reg_r;
         cell(j).reg_p = reg_p;
         cell(j).reg_int = reg_int;
         cell(j).reg_slp = reg_slp;
            else
            end
        end
        
end