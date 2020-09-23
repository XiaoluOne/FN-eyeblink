clear;

% Input parameters
  t_pre = 500;
  t_post = 250;
  dur = 2000;
  t_psth = 1000;
  bin_psth = 150;
  bin_corr = 250;
  frequency_parameters.amplifier_sample_rate = 20000;
% Import CSV file from JRCLUST
  ctp = import_ctp_csv('cell_tp.csv');
% Load spike timings
  load('16o20000_spk.mat');
  save_SpikeTrain_chanEvent(spk_time,'dat_in');
  spk(1) = struct('nr',0,'t',[]);
  spk(2) = struct('nr',1,'t',dat_in);
% Load CS/US edge
  load('16o20000_cs.mat');
  save_SpikeTrain_chanEvent(cs,'cs_lc');
  us_lc = cs_lc + 0.26;
%   us_lc(10:10:end,:) = [];
% Load opto
  load('16o20000_opto.mat');
  save_SpikeTrain_chanEvent(opto,'op_sti');
% Load eyeblink trace
  load('16o20000_blk.mat');
  save_SpikeTrain_chanWaveform(eyeblink,'v');
  t = linspace(0,(size(v,1)/20000),size(v,1));
% Detect CR/UR in eyeblink trace
  blk = blk_detn(v,t,cs_lc,us_lc,t_pre,t_post,350,dur);
% Calculte PSTH
  Copto = locs_vfy(0,op_sti,{0});
  [Cpsth,Ctas] = psth_calc(spk,Copto,20,1,t_pre,t_psth);
% Cell modulation detection
  mod_tp = cell_mod_detn(Cpsth,[-20 0],[-20 125],[-20 125]);
%Trial by trial data preparation
  ttt_cal;
% Saving
 blk_pack = dat_out_blk('16o20000',500,ctp,blk,Cpsth,mod_tp,Ctas);