function [cell] = instantanous(cell,window,step)
%window is sliding window size (0.1s,0.05s)
%step is sliding step (0.005s)

%calculate intantaneous firing rate
for l = 1:size(cell,2)
    for i = 1:size(cell(l).ttt.tss_CR,2)     
    n = 0;
    for j = -0.5:step:0.9 %step size 0.005
        ind = 0;
        n = n+1;
        for k = 1:size(cell(l).ttt.tss_CR(i).t,1)
                if cell(l).ttt.tss_CR(i).t(k) >= j && cell(l).ttt.tss_CR(i).t(k)< j+window %window size 0.05s
                    ind = ind+1;
                else
                end
        end
        cell(l).ttt.tss_CR(i).spk(n) = ind/window;%window size 0.05s
    end
    cell(l).ttt.tss_CR(i).spk = smooth(cell(l).ttt.tss_CR(i).spk);
    end
end

%normalize instantaneous firing rate (minus baseline firing rate)
for k = 1:size(cell,2) %cell
for i = 1:size(cell(k).ttt.tss_CR,2) %trial
    spk_0 = mean(cell(k).ttt.tss_CR(i).spk(1:100));
    for j = 1:size(cell(k).ttt.tss_CR(i).spk,1)
        cell(k).ttt.tss_CR(i).spk(j) = cell(k).ttt.tss_CR(i).spk(j)-spk_0;
    end
end
end

%sliding blink trace (not good to slide blk because some individual blk
%onset is really late)
%     for i = 1:size(cell,2)
%         for j = 1:size(cell(i).ttt.tss_CR,2)
%             blk = [];
%             n=0;
%             for k = 1:250
%                 a = mean(cell(i).ttt.tss_CR(j).blk(k:(50+k)));
%                 n = n+1;
%                 blk(n) = a;
%             end
%                 cell(i).ttt.tss_CR(j).blk = blk;
%         end
%     end

end

