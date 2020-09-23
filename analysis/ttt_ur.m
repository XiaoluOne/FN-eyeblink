function [cell] = ttt_ur(cell)

%for UR peak amplitude (nomalized to mean UR peak of all trials in one
%session, including CR and NO_CR trials)
for j = 1:size(cell,2)
    for i = 1:size(cell(j).ttt.tss_CR,2)+size(cell(j).ttt.tss_NO_CR,2)
        if i <= size(cell(j).ttt.tss_CR,2)
            cell(j).ttt.tss_UR(i).trial = cell(j).ttt.tss_CR(i).trial;
            cell(j).ttt.tss_UR(i).type = 'CR1'; %CR1 stands for CR trials 
            cell(j).ttt.tss_UR(i).blk = cell(j).ttt.tss_CR(i).blk;
            cell(j).ttt.tss_UR(i).spk = cell(j).ttt.tss_CR(i).spk;
        else
            n = i-size(cell(j).ttt.tss_CR,2);
            cell(j).ttt.tss_UR(i).trial = cell(j).ttt.tss_NO_CR(n).trial;
            cell(j).ttt.tss_UR(i).type = 'CR0'; %CR1 stands for NO_CR trials
            cell(j).ttt.tss_UR(i).blk = cell(j).ttt.tss_NO_CR(n).blk;
            cell(j).ttt.tss_UR(i).spk = cell(j).ttt.tss_NO_CR(n).spk;
        end
    end
end

for j = 1:size(cell,2)
            blk_max =[];
            spk_re =[];
            trial_ID = [];
            recording_ID = [];
            if isequal(cell(j).umod,'SUP') || isequal(cell(j).umod,'FAC')
            for i = 1:size(cell(j).ttt.tss_UR,2)
%      spk-blk correlation
                 blk_max = [blk_max;max(cell(j).ttt.tss_UR(i).blk(150:170))];
                 trial_ID = [trial_ID;cell(j).ttt.tss_UR(i).trial];
                 recording_ID = [recording_ID;cell(j).recording_ID];
                     if isequal(cell(j).umod,'SUP')
                         spk_re = [spk_re;0-min(cell(j).ttt.tss_UR(i).spk(150:170))]; %Modulation trough detection window: 250-350ms 
                     else isequal(cell(j).umod,'FAC')
                         spk_re = [spk_re;max(cell(j).ttt.tss_UR(i).spk(150:170))];%Modulation peak detection window: 250-350ms 
                     end    
            end
%      generate a table including spk(max/min), blk_max and trial number
         u_corr = table(spk_re(:,1),blk_max(:,1),trial_ID,'VariableNames',{'spk','blk','trial_ID'});

%        regression: mix-effect linear model (spk,trial and intercept are
%        fixed effects)
         reg = fitlm(u_corr,'blk~spk'); %if recording as random effect(1|recording)+(-1+spk|recording), PC(blk~spk),FN(blk~spk+trial_ID)
         reg_r = reg.Rsquared.Adjusted;
         reg_p = reg.Coefficients.pValue(2);
         reg_int = reg.Coefficients.Estimate(1);
         reg_slp = reg.Coefficients.Estimate(2);
         %Organize outputs in cell struct
         cell(j).u_corr = u_corr;
         cell(j).reg_r = reg_r;
         cell(j).reg_p = reg_p;
         cell(j).reg_int = reg_int;
         cell(j).reg_slp = reg_slp;
            else
            end
        end

end

