clear;

% Input parameters
  csv_name = 'testrun.csv';
  t_pre = 1000;
  t_post = 250; %for CR detection
  dur = 2000;
  t_psth = 2000; 
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
  cs_lc = find_trg_pks([adc(1).v],3,t,dur);
%   us_lc = find_trg_pks([adc(2).v],3,t,dur);
  us_lc = cs_lc + 0.25;
  %us_lc(10:10:end,:) = [];
  opto_lc = find_trg_pks([adc(3).v],3,t,dur);
% Filter eyeblink trace
  v = idv_filter([adc(4).v],1,200,0,0,0,0);
% Detect CR/UR in eyeblink trace
  blk = blk_detn(v,t,cs_lc,us_lc,t_pre,t_post,350,dur);
% find opto trials and normal trials 
  [lisa,opto] = ismember(round(opto_lc+0.5),round(cs_lc)); % 'o' is opto trial number 
   paired = cs_lc; 
   paired(opto) = []; %'paired' is paired trial number
   [lisa,paired] = ismember(round(paired),round(cs_lc));
   paired_t = cs_lc(paired);
   opto_t = cs_lc(opto);
   opto_lc = struct('nr',[],'t',[]); paired_lc = struct('nr',[],'t',[]);
   for i = 1:size(opto,1)
       opto_lc(i).nr = opto(i);
       opto_lc(i).t = opto_t(i);
   end
  for i = 1:size(paired,1)
       paired_lc(i).nr = paired(i);
       paired_lc(i).t = paired_t(i);
  end
% mark paired or opto trials in blk
for i = 1:size(blk,2)
    if ismember(i,opto)
        blk(i).type = 'opto';
    else blk(i).type = 'paired';
    end
end
% Calculate opto trial PSTH and paired trial PSTH
  [opto_psth,Otas] = psth_calc(spk,opto_lc,50,5,t_pre,t_psth);
  [paired_psth,Ptas] = psth_calc(spk,paired_lc,50,5,t_pre,t_psth);

% Generate a struct containing all PSTH structs
  PSTH = struct('cell',[],'bar_paired',[],'bar_opto',[]);
  for i = 1:size(ctp,2)
      PSTH(i).cell = paired_psth(i).cell;
      PSTH(i).bar_paired = paired_psth(i).bar;
      PSTH(i).bar_opto = opto_psth(i).bar;
  end
% Paired trial modulation detection
  paired_mod = cell_mod_detn(paired_psth,[-500 0],[0 250],[0 250]);
% Opto trials and CS_only trials modulation detection
  opto_mod = cell_mod_detn(opto_psth,[-500 0],[0 250],[0 250]);
% Generate a struct containing all mod structs 
  MOD = struct('cell',[],'stat_paired',[],'type_paired',[
      ],'onset_paired',[],'stat_opto',[],'type_opto',[],'onset_opto',[]);
  for i = 1:size(ctp,2)
      MOD(i).cell = i;
      MOD(i).stat_paired = paired_mod(i).stat;
      MOD(i).type_paired = paired_mod(i).type;
      MOD(i).onset_paired = paired_mod(i).onset;
      MOD(i).stat_opto = opto_mod(i).stat;
      MOD(i).type_opto = opto_mod(i).type;
      MOD(i).onset_opto = opto_mod(i).onset;
  end
% Prepare individual trial (CR and instantaneuos spike rate of single
% trial)
  Ptas = ttt_cal_SIO(blk,Ptas); %paired trials
  Otas = ttt_cal_SIO(blk,Otas); %opto trials
% Generate a struct containing all tas structs
  ALLtas = struct('cell',[],'tss_P',[],'tss_O',[]);
  for i = 1:size(ctp,2)
      ALLtas(i).tss_P = Ptas(i).tss;
      ALLtas(i).tss_O = Otas(i).tss;
  end
% Saving   
  blk_pack = dat_out_SIO('test2_190918_163916',500,ctp,blk,PSTH,MOD,ALLtas);