clear;

% Input parameters
  t_pre = 500;
  t_post = 250;
  dur = 2000;
% Import Intan header and path
  read_Intan_RHD2000_file;
  cd(path);
% Import Intan time vectors
  t = import_intan_time;
  t = fix_intan_time(t);
% Import Intan ADC channels vector
  adc = import_intan_adc([]);
% Detection CS/US/OPTO edge
  cs_lc = find_trg_pks([adc(1).v],0.5,t,dur); 
  us_lc = find_trg_pks([adc(2).v],0.5,t,dur);  
% Filter eyeblink trace
  v = idv_filter([adc(3).v],1,200,0,0,0,0);
% Detect CR/UR in eyeblink trace
  blk = blk_detn(v,t,cs_lc,us_lc,t_pre,t_post,350,dur);
%   blk_plot(t,blk)

% calculate blink in each condition       
   [lisa,paired] = ismember(round(us_lc),round(cs_lc+0.24)); % 'o' is opto trial number 
   c = cs_lc; 
   c(paired) = []; %'paired' is paired trial number
   [lisa,c] = ismember(round(c),round(cs_lc));
   
   for i = 1:size(c,1)
       blk(c(i)).trial = c(i);
       blk(c(i)).type = 'CS_only';
   end

   for i = 1:size(paired,1)
       blk(paired(i)).trial = paired(i);
       blk(paired(i)).type = 'paired';
   end
   blk = blk_cal(blk);

   % kick out outliners   
   outlier_kicker
   
   save('day16-probe_200909_101523.mat','blk');
   
   blk_analysis;