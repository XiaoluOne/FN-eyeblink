clear;

% Input parameters
  csv_name = '20259-05_day1_right_track1_1_bregmastim_1sec_5.1int.csv';
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
% Filter eyeblink trace
  v = idv_filter([adc(4).v],1,200,0,0,0,0);
% Detect CR/UR in eyeblink trace
  blk = blk_detn(v,t,cs_lc,us_lc,t_pre,t_post,350,dur);
%   blk_plot(t,blk);
% Calculte PSTH
   Copto = locs_vfy(0,opto,{0});
   [Opsth,Otas] = psth_calc(spk,Copto,50,5,t_pre,t_psth);
   Clocs = Copto;
% Cell modulation detection
  mod_tp = cell_mod_detn(Opsth,[-50 0],[-50 125],[-50 125]);

% Saving   
   blk_pack = dat_out_opto('opto2-FN_190918_165212',500,ctp,blk,Opsth,mod_tp,Otas);