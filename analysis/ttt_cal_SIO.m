function [tas] = ttt_cal_SIO(blk,tas)
%this function normalizes eyelid trace of each single trial out of 100%-UR
%and caculate instantaneuos spike rate of a cell in each trial 

for l = 1:size(tas,2)
    for i = 1:size(tas(l).tss,2)
    n = tas(l).tss(i).trial;
   %shorten blk trace into 600 points
    new = [];
    for j = 1:60000
        m = (j-1)*1+1;
        all = blk(n).tr(m:(1*j));
        all = mean(all);
        new = [new,all];
    end
    %normalize blk trace to 100%
%     max_new = max(new);
%     for k = 1:300
%         new(1,k) = new(1,k)/max_new*100;
%     end
    tas(l).tss(i).blk = new';
    end
end

%calculate instantaneous firing rate of each trial (with 50ms window size and 5ms step) 
for l = 1:size(tas,2)
    for i = 1:size(tas(l).tss,2)     
    n = 0;
    for j = -1:0.005:1.9 %step size 0.005
        ind = 0;
        n = n+1;
        for k = 1:size(tas(l).tss(i).t,1)
                if tas(l).tss(i).t(k) >= j && tas(l).tss(i).t(k)< j+0.05 %window size 0.05s
                    ind = ind+1;
                else
                end
        end
        tas(l).tss(i).spk(n) = ind/0.05;%window size 0.1s
    end
    tas(l).tss(i).spk = smooth(tas(l).tss(i).spk);
    end
end

%normalize spk 
for k = 1:size(tas,2)
for i = 1:size(tas(k).tss,2)
    spk_0 = mean(tas(k).tss(i).spk(1:100));
    for j = 1:size(tas(k).tss(i).spk,1)
        tas(k).tss(i).spk(j) = tas(k).tss(i).spk(j)-spk_0;
    end
end
end

end

