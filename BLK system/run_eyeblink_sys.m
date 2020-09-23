clear;

% Input parameters
  csv_name = 'spk_data.csv';
  t_pre = 500;
  t_post = 250;
  dur = 1500;
  t_psth = 1000;
  bin_psth = 150;
  bin_corr = 10;

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
% Detection CS/US edge
  cs_lc = find_trg_pks([adc(2).v],3,t,dur);
  us_lc = cs_lc + 0.26;
  us_lc(10:10:end,:) = [];
% Filter eyeblink trace
  v = idv_filter([adc(1).v],1,200,0,0,0,0);
% Detect CR/UR in eyeblink trace
  blk = blk_detn(v,t,cs_lc,us_lc,t_pre,t_post,100,dur);
  blk_plot(t,blk);
% Calculte PSTH
  Clocs = locs_vfy(1,cs_lc,{blk.cr_on});
  [Cpsth,Ctas] = psth_calc(spk,Clocs,bin_psth,t_pre,t_psth);
  Ulocs = locs_vfy(0,cs_lc,{blk.cr_on});
  [Upsth,Utas] = psth_calc(spk,Ulocs,bin_psth,t_pre,t_psth);
% Cell modulation detection
  mod_tp = cell_mod_detn(spk,Clocs,t_pre,t_post);
  blk_spk = blk_spk_calc(spk,blk,Clocs,t_pre,t_post,bin_corr);