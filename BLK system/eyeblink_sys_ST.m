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
  load('16216002_spk.mat');
  save_SpikeTrain_chanEvent(spkt,'dat_in');
  spk(1) = struct('nr',0,'t',[]);
  spk(2) = struct('nr',1,'t',dat_in);
%   load('spk4.mat');
%   save_SpikeTrain_chanEvent(spk_time,'dat_in_2');
%   spk(3) = struct('nr',2,'t',dat_in_2);
 
% Load CS/US edge
  load('16216002_cs.mat');
  save_SpikeTrain_chanEvent(cs,'cs_lc');
%   read_Intan_RHD2000_file;
%   cd(path);
%   t = import_intan_time;
%   t = fix_intan_time(t);
%   adc = import_intan_adc([]);
%   us_lc = find_trg_pks([adc(2).v],3,t,dur);
  us_lc = cs_lc + 0.25;
%   us_lc(10:10:end,:) = [];
% Load opto
%   load('17417000_opto.mat');
%   save_SpikeTrain_chanEvent(opto,'op_sti');

% Load eyeblink trace
%   v = idv_filter([adc(1).v],1,200,0,0,0,0);
  load('16216002_blk.mat');
  save_SpikeTrain_chanWaveform(blk,'v');
  t = linspace(0,(size(v,1)/20000),size(v,1));
% Detect CR/UR in eyeblink trace
  blk = blk_detn(v,t,cs_lc,us_lc,t_pre,t_post,350,dur); %-500 to 2000ms trace
%   blk_plot(t,blk);
% Calculte non_CR trial PSTH, CR trial PSTH and CS_only trial PSTH
  [non_cr_locs,cs_only_locs,Clocs] = locs(blk,cs_lc);
  [Cpsth,Ctas] = psth_calc(spk,Clocs,50,5,t_pre,t_psth);
  [NCpsth,NCtas] = psth_calc(spk,non_cr_locs,50,5,t_pre,t_psth);
%   [CSpsth,CStas] = psth_calc(spk,cs_only_locs,50,5,t_pre,t_psth);
% Generate a struct containing all PSTH structs
  PSTH = struct('cell',[],'bar_CR',[],'bar_NO_CR',[],'bar_CS_ONLY',[]);
  for i = 1:size(ctp,2)
      PSTH(i).cell = Cpsth(i).cell;
      PSTH(i).bar_CR = Cpsth(i).bar;
      PSTH(i).bar_NO_CR = NCpsth(i).bar;
%       PSTH(i).bar_CS_ONLY = CSpsth(i).bar;
  end
% CR trial modulation detection
  mod_tp = cell_mod_detn(Cpsth,[-500 0],[0 250],[0 250]);
  blk_spk = blk_spk_calc(spk,blk,Clocs,t_pre,t_post,bin_corr);
% non_CR trials and CS_only trials modulation detection
  NC_mod = cell_mod_detn(NCpsth,[-500 0],[0 250],[0 250]);
%   CS_ONLY_mod = cell_mod_detn(CSpsth,[-500 0],[0 350],[0 350]);
% Generate a struct containing all mod structs 
  MOD = struct('cell',[],'stat_CR',[],'type_CR',[],'onset_CR',[],'stat_NO_CR',[],'type_NO_CR',[],'onset_NO_CR',[],'stat_CS_ONLY',[],'type_CS_ONLY',[],'onset_CS_ONLY',[]);
  for i = 1:size(ctp,2)
      MOD(i).cell = i;
      MOD(i).stat_CR = mod_tp(i).stat;
      MOD(i).type_CR = mod_tp(i).type;
      MOD(i).onset_CR = mod_tp(i).onset;
      MOD(i).stat_NO_CR = NC_mod(i).stat;
      MOD(i).type_NO_CR = NC_mod(i).type;
      MOD(i).onset_NO_CR = NC_mod(i).onset;
%       MOD(i).stat_CS_ONLY = CS_ONLY_mod(i).stat;
%       MOD(i).type_CS_ONLY = CS_ONLY_mod(i).type;
%       MOD(i).onset_CS_ONLY = CS_ONLY_mod(i).onset;
  end
% Prepare individual trial (CR and instantaneuos spike rate of single
% trial)
  Ctas = ttt_cal(blk,Ctas); %CR trials
  NCtas = ttt_cal(blk,NCtas); %non_CR trials
%   CStas = ttt_cal(blk,CStas); %CS only trials 
% Generate a struct containing all tas structs
  ALLtas = struct('cell',[],'tss_CR',[],'tss_NO_CR',[],'tss_CS_ONLY',[]);
  for i = 1:size(ctp,2)
      ALLtas(i).cell = Ctas(i).cell;
      ALLtas(i).tss_CR = Ctas(i).tss;
      ALLtas(i).tss_NO_CR = NCtas(i).tss;
%       ALLtas(i).tss_CS_ONLY = CStas(i).tss;
  end
% Saving   
  blk_pack = dat_out_blk('16216002',500,ctp,blk,PSTH,MOD,ALLtas);