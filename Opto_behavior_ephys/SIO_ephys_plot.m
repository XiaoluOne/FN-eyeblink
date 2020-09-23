clear
%generate package of each cell type
list = dir('*.mat');
sio = struct('nr',[],'recording_ID',[]);
sio_nr = 0;

for i = 1:size(list,1)
    load (list(i).name,'-mat');
    for j = 1:size (blk_pack.SPK,2)
        if isequal(blk_pack.cell_def(j).type,'FN')
            sio_nr = sio_nr+1;
            sio(sio_nr).nr = sio_nr;
            sio(sio_nr).recording_ID = list(i).name;
            sio(sio_nr).blk_opto = blk_pack.BLK(2).tr;
            sio(sio_nr).blk_paired = blk_pack.BLK(1).tr;
            sio(sio_nr).spk_opto.trace = blk_pack.SPK(j).opto_trace;
            sio(sio_nr).spk_paired.trace = blk_pack.SPK(j).paired_trace;
            sio(sio_nr).spk_opto.psth = blk_pack.SPK(j).opto_psth;
            sio(sio_nr).spk_paired.psth = blk_pack.SPK(j).paired_psth;
            sio(sio_nr).mod_paired = blk_pack.cell_def(j).mod_paired;
            sio(sio_nr).mod_opto = blk_pack.cell_def(j).mod_opto;
            sio(sio_nr).mod_opto_only = [];
        else
        end
    end
end

%shorten paired trace to 3000
for i = 1:size(sio,2)
    new = [];
    for j = 1:3000
        n = (j-1)*20+1;
        all = sio(i).spk_paired.trace(n:(20*j)); %
        all = mean(all);
        new = [new,all];
    end
    sio(i).spk_paired.trace = new; %
end
%shorten opto trace to 3000
for i = 1:size(sio,2)
    new = [];
    for j = 1:3000
        n = (j-1)*20+1;
        all = sio(i).spk_opto.trace(n:(20*j)); %
        all = mean(all);
        new = [new,all];
    end
    sio(i).spk_opto.trace = new; %
end

% normalize trace to baseline (-500 to 0 ms, 0-100 points)
for i = 1:size(sio,2)
    baseline = mean(sio(i).spk_paired.trace(1:500));
    sio(i).spk_paired.trace = sio(i).spk_paired.trace/baseline*100;
end

for i = 1:size(sio,2)
    baseline = mean(sio(i).spk_opto.trace(1:500));
    sio(i).spk_opto.trace = sio(i).spk_opto.trace/baseline*100;
end

%calculate average trace
avr_trace = []; sd_trace =[]; co_trace =[];
for j = 1:300
    a = [];
    for i = 1:size(sio,2)
        a = [a;sio(i).spk_paired(j)]; 
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