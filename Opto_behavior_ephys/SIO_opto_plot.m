clear
%generate package of each cell type
list = dir('*.mat');
opto = struct('nr',[],'recording_ID',[],'trace',[],'mod',[]);
opto_nr = 0;

for i = 1:size(list,1)
    load (list(i).name,'-mat');
    for j = 1:size (blk_pack.freq_wfm,2)
%         if isequal(blk_pack.cell_def(j).type,'IN')
            opto_nr = opto_nr+1;
            opto(opto_nr).nr = opto_nr;
            opto(opto_nr).recording_ID = list(i).name;
            opto(opto_nr).trace = blk_pack.freq_wfm(j).tr;
            opto(opto_nr).mod = blk_pack.cell_def(j).mod;
%         else
%         end
    end
end

%shorten trace to 3000 (3s)
for i = 1:size(opto,2)
    new = [];
    for j = 1:3000
        n = (j-1)*20+1;
        all = opto(i).trace(n:(20*j));
        all = mean(all);
        new = [new,all];
    end
    opto(i).trace = new;
end

% normalize trace to baseline (-500 to 0 ms, 0-500 points)
for i = 1:size(opto,2)
    baseline = mean(opto(i).trace(1:500));
    opto(i).trace = opto(i).trace/baseline*100;
end

%calculate average trace
avr_trace = []; sd_trace =[]; co_trace =[];
for j = 1:300
    a = [];
    for i = 1:size(opto,2)
        a = [a;opto(i).trace(j)]; 
    end
    avr = mean(a);
    sd = std(a);
    co = sd/avr*100;
    avr_trace(j) = avr;
    sd_trace(j) = sd;
    co_trace(j) = co;
end
trace_up = avr_trace + co_trace;
trace_down = avr_trace - co_trace;

%plot
plot(smooth(avr_trace),'color','r');
hold on
plot(smooth(trace_up),'color','b');
hold on
plot(smooth(trace_down),'color','b');