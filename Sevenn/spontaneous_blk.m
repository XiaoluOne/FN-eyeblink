clear;

% Input parameters
  csv_name = 'spk_data.csv';
  t_pre = 1000;
  t_post = 1000; 
  dur = 1000;
  t_psth = 1000; 
  bin_psth = 200;

% Import Intan header and path
  read_Intan_RHD2000_file;
  cd(path);
% Import Intan time vectors
  t = import_intan_time;
  t = fix_intan_time(t);
% Import Intan ADC channels vector
  adc = import_intan_adc([]);
% Import CSV file from JRCLUST
  spk = import_jrc_csv(csv_name);
  ctp = import_ctp_csv('cell_tp.csv');
 
% Filter eyeblink trace
  v = idv_filter([adc(1).v],1,200,0,0,0,0);
  v = min(v)-v; %flip eyelid trace
  v = v-min(v);
% blk_short = seven_shorten(v,size(v,1),size(v,1)/20);
% blk_short = smooth(blk_short);
% blk_short = -blk_short-min(-blk_short); 
% blk_short = blk_short-mean(blk_short);
  [pk,locs] = findpeaks(smooth(v),'MinPeakProminence',0.15,'MinPeakDistance',20000,'MaxPeakWidth',10000); %find all peaks
  [cpk,clocs] = findpeaks(smooth(adc(2).v),'MinPeakProminence',1.5,'MinPeakDistance',20000); %find all cs trigger
% exclude all eyeblink trials  
  k = [];
  for i=1:size(clocs,1)
      n = locs-clocs(i);
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
blk_pack = dat_out_7n('pc5_181014_153718',1000,ctp,blk,Spsth,mod_tp,Stas);