
t = zeros(size(Ctas.tss,2),1500);
    for j = 1:size(Ctas.tss,2)
        trial = round(1000*Ctas.tss(j).t'+500);
        idx = find(~trial);
        trial(idx) = 1;
        t(j,trial) = trial;
    end
    t = logical(t);
    
    plotSpikeRaster(t,'plotType','vertline')





for i = 1:20
   Ctas.tss(i).blk = seven_shorten(Ctas.tss(i).blk,30000,300); 
end

for i = 1:15
    figure(i)
    plot(Ctas.tss(i).blk)
end



a=[];
for i = 1:15
    a = [a,Ctas.tss(i).blk];
end

plot(a,'b')
hold on
plot(mean(a'),'r')
hold on
plot(mean(a')+std(a'),'g')
hold on
plot(mean(a')-std(a'),'g')

for i = 1:15
    Ctas.tss(i).blk = Ctas.tss(i).blk-x;
end
