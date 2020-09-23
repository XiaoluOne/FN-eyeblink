clear
%generate package of each cell type
list = dir('*.mat');
FN = struct('nr',[],'recording_ID',[],'opto',[],'mod',[],'blk',[],'spk',[],'ttt',[]);
FN_fast = struct('nr',[],'recording_ID',[],'opto',[],'mod',[],'blk',[],'spk',[],'ttt',[]);
FN_slow = struct('nr',[],'recording_ID',[],'opto',[],'mod',[],'blk',[],'spk',[],'ttt',[]);
FN_nom = struct('nr',[],'recording_ID',[],'opto',[],'mod',[],'blk',[],'spk',[],'ttt',[]);

FN_nr = 0;
fast = 0;
slow = 0;
nom = 0;

for i = 1:size(list,1)
    file_name = list(i).name;
    load (file_name,'-mat');
    for j = 1:size (blk_pack.cell_def,2)
            FN_nr = FN_nr+1;
            FN(FN_nr).recording_ID = file_name;
            FN(FN_nr).opto = blk_pack.cell_def(j).type;
            FN(FN_nr).nr = FN_nr;
            FN(FN_nr).mod = blk_pack.cell_def(j).mod_CR_trial;
            FN(FN_nr).blk = blk_pack.BLK;
            FN(FN_nr).spk = blk_pack.SPK(j);
            FN(FN_nr).ttt = blk_pack.TTT(j);
            FN(FN_nr).mod_on = blk_pack.cell_def(j).mod_onset_CR_trial;
    end
end

FN = umod(FN);
FN = peaktime(FN);
% FN_plot = cell_plot(FN,89);
FN = sm(FN);

%categorize FN base on opto type(fast, slow, nom)
    for j = 1:size (FN,2)
        if isequal(FN(j).opto,'FAST')
            fast = fast+1;
            FN_fast(fast).nr = fast;
            FN_fast(fast).recording_ID = FN(j).recording_ID;
            FN_fast(fast).opto = 'FAST';
            FN_fast(fast).mod = FN(j).mod;
            FN_fast(fast).blk = FN(j).blk;
            FN_fast(fast).spk = FN(j).spk;
            FN_fast(fast).ttt = FN(j).ttt;
        elseif isequal(FN(j).opto,'SUP')
            slow = slow+1;
            FN_slow(slow).nr = slow;
            FN_slow(slow).recording_ID = FN(j).recording_ID;
            FN_slow(slow).opto = 'SUP';
            FN_slow(slow).mod = FN(j).mod;
            FN_slow(slow).blk = FN(j).blk;
            FN_slow(slow).spk = FN(j).spk;
            FN_slow(slow).ttt = FN(j).ttt;
        elseif isequal(FN(j).opto,'NOM')
            nom = nom+1;
            FN_nom(nom).nr = nom;
            FN_nom(nom).recording_ID = FN(j).recording_ID;
            FN_nom(nom).opto = 'NOM';
            FN_nom(nom).mod = FN(j).mod;
            FN_nom(nom).blk = FN(j).blk;
            FN_nom(nom).spk = FN(j).spk;
            FN_nom(nom).ttt = FN(j).ttt;
        else
        end
    end


%mean of individual subtype 
FN_fast_plot.spk_sup = [];
sd_all = [];
co_all = [];
for j = 1:300
    cal = [];
    for i = 1:size(FN_fast,2)
        if isequal(FN_fast(i).mod,'SUP')
            idv = FN_fast(i).spk.CR_trace(j);
            cal = [cal,idv];
        else
        end
    end
    avr = mean(cal);
    FN_fast_plot.spk_sup(j) = avr;
    %calculate SD of each time point, preparing for plotting
    sd = std(cal);
    co = sd/avr*100;
    sd_all = [sd_all;sd];
    co_all = [co_all;co];
end
FN_fast_plot.spk_sup = FN_fast_plot.spk_sup';
curve_up = FN_fast_plot.spk_sup + co_all;
curve_down = FN_fast_plot.spk_sup - co_all;

%plot
figure(1);
for i = 1:size(FN_fast,2)
    if isequal(FN_fast(i).mod,'SUP')
        plot (FN_fast(i).spk.CR_trace,'Color',[0.7,0.7,0.7]);
        hold on
    end
end
hold on
plot (FN_fast_plot.spk_sup,'Color',[0.8,0.35,0.35],'LineWidth',3);
hold on 
plot (curve_up,'b','LineWidth',1);
hold on
plot (curve_down,'b','LineWidth',1)