clear
%generate package of each cell type
list = dir('*.mat');
FN = struct('nr',[],'recording_ID',[],'mod',[],'blk',[],'spk',[],'ttt',[]);
FN_fac = struct('nr',[],'recording_ID',[],'mod',[],'blk',[],'spk',[],'ttt',[]);
FN_sup = struct('nr',[],'recording_ID',[],'mod',[],'blk',[],'spk',[],'ttt',[]);
FN_nom = struct('nr',[],'recording_ID',[],'mod',[],'blk',[],'spk',[],'ttt',[]);

FN_nr = 0;
fac = 0;
sup = 0;
nom = 0;

for i = 1:size(list,1)
    file_name = list(i).name;
    load (file_name,'-mat');
    for j = 1:size (blk_pack.cell_def,2)
            FN_nr = FN_nr+1;
            FN(FN_nr).recording_ID = file_name; 
            FN(FN_nr).nr = FN_nr;
            FN(FN_nr).mod = blk_pack.cell_def(j).mod_CR_trial;
            FN(FN_nr).blk = blk_pack.BLK;
            FN(FN_nr).spk = blk_pack.SPK(j);
            FN(FN_nr).ttt = blk_pack.TTT(j);
            FN(FN_nr).mod_on = blk_pack.cell_def(j).mod_onset_CR_trial;
    end
end

%CR Modulation detection window is from 0-200ms 
for i = 1:162
   if FN(i).mod_on > 200 %exclud cells with CR_mod_onset >200 
       FN(i).mod = 'NOM';
       FN(i).mod_on = [];
   else
   end
end

% FN = ur_sliding(FN);
FN = umod(FN);
FN = psth(FN,10);
FN = ttt_onset(FN);
FN = peaktime(FN);
FN_plot = cell_plot(FN,168);
FN = sm(FN);

%categorize FN base on modulation type
    for j = 1:size (FN,2)
        if isequal(FN(j).mod,'FAC')
            fac = fac+1;
            FN_fac(fac).nr = fac;
            FN_fac(fac).recording_ID = FN(j).recording_ID;
            FN_fac(fac).mod = 'FAC';
            FN_fac(fac).blk = FN(j).blk;
            FN_fac(fac).spk = FN(j).spk;
            FN_fac(fac).ttt = FN(j).ttt;
            FN_fac(fac).CR_on = FN(j).CR_on;
        elseif isequal(FN(j).mod,'SUP')
            sup = sup+1;
            FN_sup(sup).nr = sup;
            FN_sup(sup).recording_ID = FN(j).recording_ID;
            FN_sup(sup).mod = 'SUP';
            FN_sup(sup).blk = FN(j).blk;
            FN_sup(sup).spk = FN(j).spk;
            FN_sup(sup).ttt = FN(j).ttt;
            FN_sup(sup).CR_on = FN(j).CR_on;
        else 
            nom = nom+1;
            FN_nom(nom).nr = nom;
            FN_nom(nom).recording_ID = FN(j).recording_ID;
            FN_nom(nom).mod = 'NOM';
            FN_nom(nom).blk = FN(j).blk;
            FN_nom(nom).spk = FN(j).spk;
            FN_nom(nom).ttt = FN(j).ttt;
            FN_nom(nom).CR_on = FN(j).CR_on;
        end
    end
 
%find all modulating cells 
n = 1;
for i = 1:size(FN,2)
   if isequal(FN(i).mod,'FAC') || isequal(FN(i).mod,'SUP') 
       FN_MO(n) = FN(i);
       n = n+1;
   else isequal(FN(i).mod,'NOM') 
   end
end

%mean of individual subtype 
FN_plot.spk_nom = [];
sd_all = [];
co_all = [];
for j = 1:300
    cal = [];
    for i = 1:size(FN_nom,2)
        idv = FN_nom(i).spk.CR_trace(j);
        cal = [cal,idv];
    end
    avr = mean(cal);
    FN_plot.spk_nom(j) = avr;
    %calculate SD of each time point, preparing for plotting
    sd = std(cal);
    co = sd/avr*100;
    sd_all = [sd_all;sd];
    co_all = [co_all;co];
end
FN_plot.spk_nom = FN_plot.spk_nom';
curve_up = FN_plot.spk_nom + co_all;
curve_down = FN_plot.spk_nom - co_all;

%plot
figure(1);
for i = 1:size(FN_nom,2)
    plot (FN_nom(i).spk.CR_trace,'Color',[0.7,0.7,0.7]);
    hold on
end
hold on
plot (FN_plot.spk_nom,'Color',[0.8,0.35,0.35],'LineWidth',3);
hold on 
plot (curve_up,'b','LineWidth',1);
hold on
plot (curve_down,'b','LineWidth',1)