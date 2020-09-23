clear;

% Input parameters
  t_pre = 500;
  t_post = 250;
  dur = 2000;
  t_psth = 1000;
  bin_psth = 150;
  bin_corr = 10;

% Load CS/US edge
  load('16523005_cs.mat');
  save_SpikeTrain_chanEvent(cs,'cs_lc');
  us_lc = cs_lc + 0.26;
%   us_lc(7:10:end,:) = [];
% % Load opto
%   load('16523000_opto.mat');
%   save_SpikeTrain_chanEvent(opto,'op_sti');
% Load eyeblink trace
  load('16523005_blk.mat');
  save_SpikeTrain_chanWaveform(blk,'v');
  t = linspace(0,(size(v,1)/20000),size(v,1));
% Detect CR/UR in eyeblink trace
  blk = blk_detn(v,t,cs_lc,us_lc,t_pre,t_post,350,dur);
%   blk_plot(t,blk);

% calculate blink in each condition
%   [lisa,o] = ismember(round(op_sti),round(cs_lc)); % 'o' is opto trial number 
%    paired = cs_lc; 
%    paired(o) = []; %'paired' is paired trial number
%    [lisa,paired] = ismember(round(paired),round(cs_lc));
  
  [lisa,paired] = ismember(round(us_lc-0.26),round(cs_lc));%'c' is CS_only trial number
  c = cs_lc;
  c(paired) = [];
  [lisa,c] = ismember(round(c),round(cs_lc));
  
%   for i = 1:size(o,1)
%        blk(o(i)).trial = o(i);
%        blk(o(i)).type = 'opto';
%   end
   
     for i = 1:size(c,1)
       blk(c(i)).trial = c(i);
       blk(c(i)).type = 'CS_only';
     end

   for i = 1:size(paired,1)
       blk(paired(i)).trial = paired(i);
       blk(paired(i)).type = 'paired';
   end
%    blk = blk_cal(blk);
   

% Saving   
save('11486-01_after1','blk');

