%shorten blk and spk trace to 1500 (-500 to 1000)
for i = 1:size(seven,2)
    seven(i).blk = seven_shorten(seven(i).blk.tr,30000,1500);
    for j = 1:size(seven(i).spk,2)
        seven(i).spk(j).tr = seven_shorten(seven(i).spk(j).tr,30000,1500);
    end
end

%shorten and normalize blk trace of each trial
for i = 1:size(seven,2)
    if isequal(seven(i).cell_def(1).type,'testrun')
        for j = 1:size(seven(i).spk,2)
            ur = [];
            for k = 1:size(seven(i).ttt(j).tss,2)
                %shorten blk trace of every trial
                seven(i).ttt(j).tss(k).blk = seven_shorten(seven(i).ttt(j).tss(k).blk,30000,300);
            end
        end
    else 
    end
end 

for i = 1:size(seven,2)
    if isequal(seven(i).cell_def(1).type,'testrun')
        for j = 1:size(seven(i).spk,2)
            blk_max = [];
            for k = 1:size(seven(i).ttt(j).tss,2)
                %find max of each blk trace
                blk_max = [blk_max;max(seven(i).ttt(j).tss(k).blk(150:170))];
            end
            blk_max = mean(blk_max');
            for k = 1:size(seven(i).ttt(j).tss,2)
                %normalize each blk trace 
                seven(i).ttt(j).tss(k).blk = seven(i).ttt(j).tss(k).blk/blk_max*100;
            end
        end
    else 
    end
end 


%trial to trial 
for i = 1:size(seven,2)
    if isequal(seven(i).cell_def(1).type,'testrun')
        for j = 1:size(seven(i).spk,2)
            blk_max = [];
            spk_re = [];
            trial_ID = [];
            if ~isequal(seven(i).cell_def(j).mod,'NOM')
                for k = 1:size(seven(i).ttt(j).tss,2)
                    if max(seven(i).ttt(j).tss(k).blk(110:140))>=3 
                        blk_max = [blk_max;max(seven(i).ttt(j).tss(k).blk(110:140))];
                        trial_ID = [trial_ID;seven(i).ttt(j).tss(k).trial];
                            if isequal(seven(i).cell_def(j).mod,'SUP')
                                 spk_re = [spk_re;0-min(seven(i).ttt(j).tss(k).spk(110:140))]; %Modulation trough detection window: 0-150ms 
                            elseif isequal(seven(i).cell_def(j).mod,'FAC')
                                 spk_re = [spk_re;max(seven(i).ttt(j).tss(k).spk(110:140))];%Modulation peak detection window: 0-150ms
                            else 
                            end
                    else
                    end
                end
                corr = table(spk_re(:,1),blk_max(:,1),trial_ID,'VariableNames',{'spk','blk','trial_ID'});
                reg = fitlm(corr,'blk~spk'); %if recording as random effect(1|recording)+(-1+spk|recording), PC(blk~spk),FN(blk~spk+trial_ID)
                reg_r = reg.Rsquared.Adjusted;
                reg_p = reg.Coefficients.pValue(2);
                reg_int = reg.Coefficients.Estimate(1);
                reg_slp = reg.Coefficients.Estimate(2);
                %Organize outputs in cell struct
                seven(i).ttt(j).corr = corr;
                seven(i).ttt(j).reg_r = reg_r;
                seven(i).ttt(j).reg_p = reg_p;
                seven(i).ttt(j).reg_int = reg_int;
                seven(i).ttt(j).reg_slp = reg_slp;
            else
            end
        end
    else 
    end
end 
       
           
    
      

