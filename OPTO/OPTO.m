clear
%generate package of each cell type
list = dir('*.mat');
opto = struct('nr',[],'recording_ID',[],'mod',[],'onset',[],'blk',[],'spk',[],'ttt',[]);
opto_fast = struct('nr',[],'recording_ID',[],'mod',[],'blk',[],'spk',[],'ttt',[]);
opto_slow = struct('nr',[],'recording_ID',[],'mod',[],'blk',[],'spk',[],'ttt',[]);

opto_nom = struct('nr',[],'recording_ID',[],'mod',[],'blk',[],'spk',[],'ttt',[]);

opto_nr = 0;
fac = 0;
sup = 0;
nom = 0;

for i = 1:size(list,1)
    file_name = list(i).name;
    load (file_name,'-mat');
    for j = 1:size (blk_pack.cell_def,2)
            opto_nr = opto_nr+1;
            opto(opto_nr).recording_ID = file_name;
            opto(opto_nr).nr = opto_nr;
            opto(opto_nr).mod = blk_pack.cell_def(j).type;
            opto(opto_nr).onset = blk_pack.cell_def(j).mod_onset;
            opto(opto_nr).blk = blk_pack.blk_wfm;
            opto(opto_nr).spk = blk_pack.freq_wfm(j).tr;
            opto(opto_nr).ttt = blk_pack.cell_reg(j).tss;
    end
end

%categorize opto base on modulation type
    for j = 1:size (opto,2)
        if isequal(opto(j).mod,'FAST')
            fac = fac+1;
            opto_fast(fac).nr = fac;
            opto_fast(fac).recording_ID = opto(j).recording_ID;
            opto_fast(fac).mod = 'FAST';
            opto_fast(fac).blk = opto(j).blk;
            opto_fast(fac).spk = opto(j).spk;
            opto_fast(fac).ttt = opto(j).ttt;
        elseif isequal(opto(j).mod,'SUP')
            sup = sup+1;
            opto_slow(sup).nr = sup;
            opto_slow(sup).recording_ID = opto(j).recording_ID;
            opto_slow(sup).mod = 'SLOW';
            opto_slow(sup).blk = opto(j).blk;
            opto_slow(sup).spk = opto(j).spk;
            opto_slow(sup).ttt = opto(j).ttt;
        else isequal(opto(j).mod,'NOM')
            nom = nom+1;
            opto_nom(nom).nr = nom;
            opto_nom(nom).recording_ID = opto(j).recording_ID;
            opto_nom(nom).mod = 'NOM';
            opto_nom(nom).blk = opto(j).blk;
            opto_nom(nom).spk = opto(j).spk;
            opto_nom(nom).ttt = opto(j).ttt;
        end
    end
    
opto_plot = opto_plot(opto,opto_nr);
%MIN_plot = cell_plot(MIN,MIN_nr);    

%smooth eyelid/spike trace (not for PC_plot)
opto_slow = sm(opto_slow);
opto_fast = sm(opto_fast);
opto = sm(opto);
opto_nom = sm(opto_nom);

%mean of individual subtype 
opto_plot.spk_nom = [];
sd_all = [];
co_all = [];
for j = 1:300
    cal = [];
    for i = 1:size(opto_nom,2)
        idv = opto_nom(i).spk(j);
        cal = [cal,idv];
    end
    avr = mean(cal);
    opto_plot.spk_nom(j) = avr;
    %calculate SD of each time point, preparing for plotting
    sd = std(cal);
    sd_all = [sd_all;sd];
    co = sd/avr*100;
    co_all = [co_all;co];
end
opto_plot.spk_nom = opto_plot.spk_nom';
curve_up = opto_plot.spk_nom + co_all;
curve_down = opto_plot.spk_nom - co_all;

%plot
figure(1);
for i = 1:size(opto_nom,2)
    plot (opto_nom(i).spk,'Color',[0.7,0.7,0.7]);
    hold on
end
hold on
plot (opto_plot.spk_nom,'Color',[0.8,0.35,0.35],'LineWidth',3);
hold on 
plot (curve_up,'b','LineWidth',1);
hold on
plot (curve_down,'b','LineWidth',1)