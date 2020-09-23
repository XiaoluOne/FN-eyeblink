clear;

% Input parameters
  t_pre = 500;
  t_post = 250;
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
% Detection CS/US/OPTO edge
  %opto = find_trg_pks([adc(3).v],0.5,t,dur);
  cs_lc = find_trg_pks([adc(1).v],0.5,t,dur); 
  us_lc = find_trg_pks([adc(2).v],0.5,t,dur);
%   us_lc(5:5:end,:) = []; %for CS-only testrun
%   [lisa,o] = ismember(round(opto+0.5),round(cs_lc)); %for opto-CS-only trials   
%   us_lc(o) = []; 
  
% Filter eyeblink trace
  v = idv_filter([adc(3).v],1,200,0,0,0,0);
% Detect CR/UR in eyeblink trace
  blk = blk_detn(v,t,cs_lc,us_lc,t_pre,t_post,350,dur);
%   blk_plot(t,blk)

% calculate blink in each condition    
   [lisa,o] = ismember(round(opto),round(cs_lc)); % 'o' is opto trial number 
   paired = cs_lc; 
   paired(o) = []; %'paired' is paired trial number
   [lisa,paired] = ismember(round(paired),round(cs_lc));
   [lisa,paired] = ismember(round(us_lc-0.26),round(cs_lc));%'c' is CS_only trial number
c = cs_lc;
c(paired) = [];
[lisa,c] = ismember(round(c),round(cs_lc));

   
%    for i = 1:size(o,1)
%        blk(o(i)).trial = o(i);
%        blk(o(i)).type = 'opto';
%    end
   
   for i = 1:size(c,1)
       blk(c(i)).trial = c(i);
       blk(c(i)).type = 'CS_only';
   end

   for i = 1:size(paired,1)
       blk(paired(i)).trial = paired(i);
       blk(paired(i)).type = 'paired';
   end
   blk = blk_cal(blk);
   
%    save('0-2000_190206_132217.mat','blk');