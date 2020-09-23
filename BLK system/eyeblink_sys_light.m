clear;

% Input parameters
  csv_name = 'spk.csv';
  t_pre = 500;
  t_post = 250; %for CR detection
  dur = 2000;
  t_psth = 1000; 
  bin_psth = 150;
  bin_corr = 250;

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
% Detection CS/US edge
  cs_lc = find_trg_pks([adc(1).v],0.5,t,dur); %treat opto as cs
  us_lc = cs_lc + 0.25; %no us actually
%   us_lc(10:10:end,:) = [];
  opto = find_trg_pks([adc(3).v],0.5,t,dur);
  Olocs = locs_vfy(0,opto,{0});
  [Opsth,Otas] = psth_calc(spk,Olocs,50,5,t_pre,t_psth);
% Filter eyeblink trace
  v = idv_filter([adc(4).v],1,200,0,0,0,0);
% Detect CR/UR in eyeblink trace
%   [lisa,a] = ismember(opto,cs_lc);
%   cs_lc(a) = [];
  blk = blk_detn(v,t,cs_lc,us_lc,t_pre,t_post,350,dur);
%   blk_plot(t,blk);
% Calculte PSTH
   Clocs = locs_vfy(0,cs_lc,{0});
   [Cpsth,Ctas] = psth_calc(spk,Clocs,50,5,t_pre,t_psth);
% Cell modulation detection
  mod_tp = cell_mod_detn(Cpsth,[-500 0],[0 250],[0 250]);
% trial to trial data
  Ctas = ttt_cal(blk,Ctas);
% Saving   
   blk_pack = dat_out_7n('opto4_190118_172935',500,ctp,blk,Cpsth,mod_tp,Ctas);