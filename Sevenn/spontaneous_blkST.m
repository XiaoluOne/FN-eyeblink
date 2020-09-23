clear;

% Input parameters
  csv_name = 'spk_data.csv';
  t_pre = 1000;
  t_post = 1000; 
  dur = 1000;
  t_psth = 1000; 
  bin_psth = 200;
  frequency_parameters.amplifier_sample_rate = 20000;
% Load CS/US edge
  load('16216002_cs.mat');
  save_SpikeTrain_chanEvent(cs,'cs_lc');
  cs_lc = cs_lc*20000;
% Import CSV file from JRCLUST
  ctp = import_ctp_csv('cell_tp.csv');

% Load spike timings
  load('16216002_spk.mat');
  save_SpikeTrain_chanEvent(spkt,'dat_in');
  spk(1) = struct('nr',0,'t',[]);
  spk(2) = struct('nr',1,'t',dat_in);
  
% Load eyeblink trace
  load('16216002_blk.mat');
  save_SpikeTrain_chanWaveform(blk,'v');
  t = linspace(0,(size(v,1)/20000),size(v,1));
  v = min(v)-v; %flip eyelid trace
  v = v-min(v);
  
  [pk,locs] = findpeaks(smooth(v),'MinPeakProminence',0.5,'MinPeakDistance',20000,'MaxPeakWidth',10000); %find all peaks

% exclude all eyeblink trials  
  k = [];
  for i=1:size(cs_lc,1)
      n = locs-cs_lc(i);
      a = find(n<10000 & n>0);
      k = [k,a];
  end
  locs(k) = [];
  
  for i = 1:size(locs,1)
      Slocs(i).nr = i;
      Slocs(i).t = t(locs(i));
  end
  
% blk detection
    blk = struct();
    for i = 1:size(locs,1)
        blk_0 = locs(i)-t_pre*20;
        blk_1 = locs(i)+ t_post*20;
        blk(i).nr = i;
        blk(i).tr = v(blk_0:blk_1-1);
    end
% normalize each spontaneous blinking to baseline (minus baseline)    
for i = 1:size(blk,2)
    a = mean(blk(i).tr(1:5000));
    blk(i).tr = blk(i).tr-a;
end
% PSTH for each cell
[Spsth,Stas] = psth_calc(spk,Slocs,50,5,t_pre,t_psth);
% Modulation 
mod_tp = cell_mod_detn(Spsth,[-500 0],[-500 500],[-500 500]);
Stas = ttt_cal(blk,Stas);
% data out
blk_pack = dat_out_7n('16216002',1000,ctp,blk,Spsth,mod_tp,Stas);