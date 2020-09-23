function [t] = raster(cell,n )
%input n: array the numbers of cells that you want to plot 

for i = n
    t = zeros(size(cell(i).CS_ttt.tss_CR,2),1500);
    for j = 1:size(cell(i).CS_ttt.tss_CR,2)
        trial = round(1000*cell(i).CS_ttt.tss_CR(j).t'+500);
        idx = find(~trial);
        trial(idx) = 1;
        t(j,trial) = trial;
    end
    t = logical(t);
    figure(i);
    plotSpikeRaster(t,'plotType','vertline')
end

end

