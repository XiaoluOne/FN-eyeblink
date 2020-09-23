clear
list = dir('*.mat');
PC_cpx = struct('nr',[],'recording_ID',[],'SS_nr',[],'mod',[],'mod_on',[],'blk',[],'spk',[],'ttt',[],'no_CR_mod',[]);
cpx_cs_fac = struct('nr',[],'recording_ID',[],'mod',[],'mod_on',[],'blk',[],'spk',[],'ttt',[],'CR_on',[]);
cpx_us_fac = struct('nr',[],'recording_ID',[],'mod',[],'mod_on',[],'blk',[],'spk',[],'ttt',[],'CR_on',[]);
cpx_cs_nom = struct('nr',[],'recording_ID',[],'mod',[],'blk',[],'spk',[],'ttt',[],'CR_on',[]);
cpx_us_nom = struct('nr',[],'recording_ID',[],'mod',[],'blk',[],'spk',[],'ttt',[],'CR_on',[]);

cpx_nr = 0;
cs = 0;
us = 0;
nom = 0;

for i = 1:size(list,1)
    file_name = list(i).name;
    load (file_name,'-mat');
    for j = 1:size (blk_pack.cell_def,2)
            cpx_nr = cpx_nr+1;
            PC_cpx(cpx_nr).recording_ID = file_name;
            PC_cpx(cpx_nr).nr = cpx_nr;
            PC_cpx(cpx_nr).SS_nr = blk_pack.cell_def(j).nr;
            PC_cpx(cpx_nr).mod = blk_pack.cell_def(j).mod_CR_trial;
            PC_cpx(cpx_nr).mod_on = blk_pack.cell_def(j).mod_onset_CR_trial;
            PC_cpx(cpx_nr).blk = blk_pack.BLK;
            PC_cpx(cpx_nr).spk = blk_pack.SPK(j);
            PC_cpx(cpx_nr).ttt = blk_pack.TTT(j);
            PC_cpx(cpx_nr).no_CR_mod = blk_pack.cell_def(j).mod_NO_CR;
    end
end

PC_cpx = umod(PC_cpx);
PC_cpx = peaktime(PC_cpx);
cpx_plot = cpx_plot(PC_cpx,cpx_nr);
PC_cpx = sm(PC_cpx);

%categorize PC base on modulation type
    for j = 1:size (PC_cpx,2)
        if isequal(PC_cpx(j).mod,'FAC')
            cs = cs+1;
            cpx_cs_fac(cs).nr = cs;
            cpx_cs_fac(cs).recording_ID = PC_cpx(j).recording_ID;
            cpx_cs_fac(cs).mod = 'FAC';
            cpx_cs_fac(cs).mod_on = PC_cpx(j).mod_on;
            cpx_cs_fac(cs).blk = PC_cpx(j).blk;
            cpx_cs_fac(cs).spk = PC_cpx(j).spk;
            cpx_cs_fac(cs).ttt = PC_cpx(j).ttt;
            cpx_cs_fac(cs).CR_on = PC_cpx(j).CR_on;
        
        else 
            nom = nom+1;
            cpx_cs_nom(nom).nr = nom;
            cpx_cs_nom(nom).recording_ID = PC_cpx(j).recording_ID;
            cpx_cs_nom(nom).mod = 'NOM';
            cpx_cs_nom(nom).mod_on = PC_cpx(j).mod_on;
            cpx_cs_nom(nom).blk = PC_cpx(j).blk;
            cpx_cs_nom(nom).spk = PC_cpx(j).spk;
            cpx_cs_nom(nom).ttt = PC_cpx(j).ttt;
            cpx_cs_nom(nom).CR_on = PC_cpx(j).CR_on;
        end
    end
    
      

%mean of individual subtype 
cpx_plot.spk_fac = [];
sd_all = [];
co_all = [];
for j = 1:300
    cal = [];
    for i = 1:size(cpx_cs_fac,2)
        idv = cpx_cs_fac(i).spk.CR_trace(j);
        cal = [cal,idv];
    end
    avr = mean(cal);
    cpx_plot.spk_fac(j) = avr;
    %calculate SD of each time point, preparing for plotting
    sd = std(cal);
    co = sd/avr*100;
    co_all = [co_all;co];
    sd_all = [sd_all;sd];
end
cpx_plot.spk_fac = cpx_plot.spk_fac';
curve_up = cpx_plot.spk_fac + sd_all;
curve_down = cpx_plot.spk_fac - sd_all;

 
%plot
figure(1);
for i = 1:size(cpx_cs_fac,2)
    plot (cpx_cs_fac(i).spk.CR_trace,'Color',[0.7,0.7,0.7]);
    hold on
end
% hold on
% plot (time,amp,'.','MarkerEdgeColor','b','MarkerSize',30); %onset plot
hold on
plot (cpx_plot.spk_fac,'Color',[0.8,0.35,0.35],'LineWidth',3);
hold on 
plot (curve_up,'r','LineWidth',1);
hold on
plot (curve_down,'r','LineWidth',1);