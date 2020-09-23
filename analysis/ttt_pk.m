function [cell ] = ttt_pk( cell )
        
%find onset of each trial
cell = ttt_onset(cell);

%exclude NON_CR trials and CS_only trials 
for i = 1:size(cell,2)
    idx = [];
    for j = 1:size(cell(i).ttt.tss_CR,2)
        if isempty(cell(i).ttt.tss_CR(j).CR_on) || isempty(cell(i).ttt.tss_CR(j).t);
            idx = [idx;j];
        else
        end
    end
    cell(i).ttt.tss_CR(idx) = [];
end        

for j = 1:size(cell,2)
            blk_max =[];
            spk_re =[];
            trial_ID = [];
            if isequal(cell(j).mod,'SUP') || isequal(cell(j).mod,'FAC')
                a=[];
            for i = 1:size(cell(j).ttt.tss_CR,2)
%    2. spk-blk correlation 
%                  if max(cell(j).ttt.tss_CR(i).blk(110:150)) >= 5 && max(cell(j).ttt.tss_CR(i).spk(110:150)) <= 500 && max(cell(j).ttt.tss_CR(i).blk(110:150)) < 95 %remove blk outliers (amp<3%)
                     blk_max = [blk_max;max(cell(j).ttt.tss_CR(i).blk(110:140))];
                     trial_ID = [trial_ID;cell(j).ttt.tss_CR(i).trial];
                         if isequal(cell(j).mod,'SUP')
                             spk_re = [spk_re;0-min(cell(j).ttt.tss_CR(i).spk(100:140))]; %Modulation trough detection window: 0-150ms 
                         elseif isequal(cell(j).mod,'FAC')
                             spk_re = [spk_re;max(cell(j).ttt.tss_CR(i).spk(100:140))];%Modulation peak detection window: 0-150ms
                         else 
                         end
%                  else
%                      a = [a,i];
%                  end        
            end
            cell(j).ttt.tss_CR(a) = [];
            
%          generate a table including spk(max/min), blk_max and trial number
         corr = table(spk_re(:,1),blk_max(:,1),trial_ID,'VariableNames',{'spk','blk','trial_ID'});

%        regression: mix-effect linear model (spk,trial and intercept are
%        fixed effects)
         reg = fitlm(corr,'blk~spk'); %if recording as random effect(1|recording)+(-1+spk|recording), PC(blk~spk),FN(blk~spk+trial_ID)
         reg_r = reg.Rsquared.Adjusted;
         reg_p = reg.Coefficients.pValue(2);
         reg_int = reg.Coefficients.Estimate(1);
         reg_slp = reg.Coefficients.Estimate(2);
         %Organize outputs in cell struct
         cell(j).corr_cr = corr;
         cell(j).reg_r_cr = reg_r;
         cell(j).reg_p_cr = reg_p;
         cell(j).reg_int_cr = reg_int;
         cell(j).reg_slp_cr = reg_slp;
            else
            end
        end
    
end

