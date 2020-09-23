clear
%sort files by cell type (purkinje, interneuron)
%generate package of each cell type
%comment the script during CS_SS analysis when there is SS CS comment behind it
list = dir('*.mat');
PC_ss = struct('nr',[],'recording_ID',[],'SS_nr',[],'mod',[],'mod_on',[],'blk',[],'spk',[],'ttt',[],'CR_on',[],'no_CR_mod',[]);
PC_fac = struct('nr',[],'recording_ID',[],'mod',[],'mod_on',[],'blk',[],'spk',[],'ttt',[],'CR_on',[]);
PC_sup = struct('nr',[],'recording_ID',[],'mod',[],'mod_on',[],'blk',[],'spk',[],'ttt',[],'CR_on',[]);
PC_nom = struct('nr',[],'recording_ID',[],'mod',[],'blk',[],'spk',[],'ttt',[],'CR_on',[]);
MIN = struct('nr',[],'recording_ID',[],'mod',[],'mod_on',[],'blk',[],'spk',[],'ttt',[]);
MIN_fac = struct('nr',[],'mod',[],'onset',[],'blk',[],'spk',[],'ttt',[]);
%MIN_sup = struct('nr',[],'mod',[],'blk',[],'spk',[],'corr',[]);
PC_nr = 0;
MIN_nr = 0;
fac = 0;
sup = 0;
nom = 0;

for i = 1:size(list,1)
    file_name = list(i).name;
    load (file_name,'-mat');
    for j = 1:size (blk_pack.cell_def,2)
        if isequal(blk_pack.cell_def(j).type,'PC_SS')
            PC_nr = PC_nr+1;
            PC_ss(PC_nr).nr = PC_nr;
            PC_ss(PC_nr).recording_ID = file_name;
            PC_ss(PC_nr).SS_nr = blk_pack.cell_def(j).nr;
            PC_ss(PC_nr).mod = blk_pack.cell_def(j).mod_CR_trial;
            PC_ss(PC_nr).mod_on = blk_pack.cell_def(j).mod_onset_CR_trial;
            PC_ss(PC_nr).blk = blk_pack.BLK;
            PC_ss(PC_nr).spk = blk_pack.SPK(j);
            PC_ss(PC_nr).ttt = blk_pack.TTT(j);
            PC_ss(PC_nr).no_CR_mod = blk_pack.cell_def(j).mod_NO_CR;
%         elseif isequal(blk_pack.cell_def(j).type,'MIN')
%             MIN_nr = MIN_nr+1;
%             MIN(MIN_nr).recording_ID = file_name;
%             MIN(MIN_nr).nr = MIN_nr;
%             MIN(MIN_nr).mod_on = blk_pack.cell_def(j).mod;
%             MIN(MIN_nr).onset = blk_pack.cell_def(j).mod_onset;
%             MIN(MIN_nr).blk = blk_pack.blk_wfm;
%             MIN(MIN_nr).spk = blk_pack.freq_wfm(j).tr;
%             MIN(MIN_nr).ttt = blk_pack.cell_reg(j).tss;
        else 
        end
    end
end

PC_ss = umod(PC_ss);
PC_ss = peaktime(PC_ss);
PC_plot = cell_plot(PC_ss,PC_nr);
PC_ss = sm(PC_ss);

%categorize PC base on modulation type
    for j = 1:size (PC_ss,2)
        if isequal(PC_ss(j).mod,'FAC')
            fac = fac+1;
            PC_fac(fac).nr = fac;
            PC_fac(fac).recording_ID = PC_ss(j).recording_ID;
            PC_fac(fac).mod = 'FAC';
            PC_fac(fac).mod_on = PC_ss(j).mod_on;
            PC_fac(fac).blk = PC_ss(j).blk;
            PC_fac(fac).spk = PC_ss(j).spk;
            PC_fac(fac).ttt = PC_ss(j).ttt;
            PC_fac(fac).CR_on = PC_ss(j).CR_on;
        elseif isequal(PC_ss(j).mod,'SUP')
            sup = sup+1;
            PC_sup(sup).nr = sup;
            PC_sup(sup).recording_ID = PC_ss(j).recording_ID;
            PC_sup(sup).mod = 'SUP';
            PC_sup(sup).mod_on = PC_ss(j).mod_on;
            PC_sup(sup).blk = PC_ss(j).blk;
            PC_sup(sup).spk = PC_ss(j).spk;
            PC_sup(sup).ttt = PC_ss(j).ttt;
            PC_sup(sup).CR_on = PC_ss(j).CR_on;
        else 
            nom = nom+1;
            PC_nom(nom).nr = nom;
            PC_nom(nom).recording_ID = PC_ss(j).recording_ID;
            PC_nom(nom).mod = 'NOM';
            PC_nom(nom).mod_on = PC_ss(j).mod_on;
            PC_nom(nom).blk = PC_ss(j).blk;
            PC_nom(nom).spk = PC_ss(j).spk;
            PC_nom(nom).ttt = PC_ss(j).ttt;
            PC_nom(nom).CR_on = PC_ss(j).CR_on;
        end
    end
    
%categorize MIN base on modulation type (MIN no supression)
%     for j = 1:size (MIN,2)
%         if isequal(MIN(j).mod,'FAC')
%             fac = fac+1;
%             MIN_fac(fac).nr = fac;
%             MIN_fac(fac).recording_ID = MIN(j).recording_ID;
%             MIN_fac(fac).mod = 'FAC';
%             MIN_fac(fac).blk = MIN(j).blk;
%             MIN_fac(fac).spk = MIN(j).spk;
%             MIN_fac(fac).ttt = MIN(j).ttt;
%         else 
%         end
%     end
      

%mean of individual subtype 
PC_plot.spk_sup = [];
sd_all = [];
co_all = [];
for j = 1:300
    cal = [];
    for i = 1:size(PC_sup,2)
        idv = PC_sup(i).spk.CR_trace(j);
        cal = [cal,idv];
    end
    avr = mean(cal);
    PC_plot.spk_sup(j) = avr;
    %calculate SD of each time point, preparing for plotting
    sd = std(cal);
    co = sd/avr*100;
    co_all = [co_all;co];
    sd_all = [sd_all;sd];
end
PC_plot.spk_sup = PC_plot.spk_sup';
curve_up = PC_plot.spk_sup + co_all;
curve_down = PC_plot.spk_sup - co_all;


%find all modulating cells 
n = 1;
for i = 1:size(PC_ss,2)
   if isequal(PC_ss(i).mod,'FAC') || isequal(PC_ss(i).mod,'SUP') 
       PC_MO(n) = PC_ss(i);
       n = n+1;
   else isequal(PC_ss(i).mod,'NOM') 
   end
end
 
%plot
figure(1);
for i = 1:size(PC_sup,2)
    plot (PC_sup(i).spk.CR_trace,'Color',[0.7,0.7,0.7]);
    hold on
end
% hold on
% plot (time,amp,'.','MarkerEdgeColor','b','MarkerSize',30); %onset plot
hold on
plot (PC_plot.spk_sup,'Color',[0.8,0.35,0.35],'LineWidth',3);
hold on 
plot (curve_up,'r','LineWidth',1);
hold on
plot (curve_down,'r','LineWidth',1);