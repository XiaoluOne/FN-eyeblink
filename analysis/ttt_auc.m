function [cell] = ttt_auc(cell)

%find onset of each trial
cell = onset(cell);

%exclude NON_CR trials
for i = 1:size(cell,2)
    idx = [];
    for j = 1:size(cell(i).ttt,2)
        if isempty(cell(i).ttt(j).CR_on);
            idx = [idx;j];
        else
        end
    end
    cell(i).ttt(idx) = [];
end

%spk count
for i = 1:size(cell,2)
    for j = 1:size(cell(i).ttt,2)
        bsl_ct = 0;
        cs_ct = 0;
        for k = 1:size(cell(i).ttt(j).t,1)
            if cell(i).ttt(j).t(k) >= -0.25 && cell(i).ttt(j).t(k) < 0
                bsl_ct = bsl_ct+1;
            elseif cell(i).ttt(j).t(k) >= 0 && cell(i).ttt(j).t(k) < 0.25
                cs_ct = cs_ct+1;
            else
            end
        end
        cell(i).ttt(j).spk_ct = cs_ct-bsl_ct;
    end
end

%blk integral~spk count correlation
for j = 1:size(cell,2)
            blk_auc =[];
            spk_auc =[];
            trial_ID = [];
            recording_ID = [];
            idx = [];
           for i = 1:size(cell(j).ttt,2)
                 x = [100:150];
                 if max(cell(j).ttt(i).blk(110:150)) >= 5 && max(cell(j).ttt(i).spk(110:150)) <= 500 && max(cell(j).ttt(i).blk(110:150)) < 95 %remove blk outliers (amp<3%)
                     trial_ID = [trial_ID;cell(j).ttt(i).trial];
                     recording_ID = [recording_ID;cell(j).recording_ID];
                     y = cell(j).ttt(i).blk(100:150); %integral for eyelid trace
                     auc = abs(trapz(x,y));
                     blk_auc = [blk_auc;auc];    
                     if isequal(cell(j).mod,'SUP') %integral for spk
                         spk_auc = [spk_auc;0-cell(j).ttt(i).spk_ct];
                     elseif isequal(cell(j).mod,'FAC')
                         spk_auc = [spk_auc;cell(j).ttt(i).spk_ct];
                     else
                     end
                 else 
                 end 
           end
           
%        generate a table including spk(max/min), blk_max and trial number
         corr = table(spk_auc(:,1),blk_auc(:,1),trial_ID,'VariableNames',{'spk','blk','trial_ID'});

%        regression: mix-effect linear model (spk,trial and intercept are
%        fixed effects)
         reg = fitlm(corr,'blk~spk'); %if recording as random effect(1|recording)+(-1+spk|recording)
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
end

end