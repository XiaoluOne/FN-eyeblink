% Calculate and save eyeblink related statistical values.
% (c) Si-yang Yu @ PSI 2018

% Function input:  filename, name used to identify output file
%                  t_pre,    pre-trigger time to be analyzed (ms)
%                  cell_tp,  defined as an array of struct (2 fields, defined below), generated by 'import_ctp_csv.m'
%                              nr:   the cell number
%                              type: the cell type
%                  blk_data, defined as an array of struct (9 fields, defined below), generated by 'blk_detn.m'
%                              tr:      baseline adjusted eyeblink trace
%                              t:       session timestamps
%                              cr_on:   CR onset time
%                              cr_pk:   CR peak time
%                              cr_amp:  CR peak amplitude
%                              eff_pk:  US onset time when CR onset exist
%                              eff_amp: eyelid amplitude at US onset time 
%                              ur_pk:   UR peak time
%                              ur_amp:  UR peak amplitude
%                  psth,     defined as an array of struct (2 fields, defined below), generated by 'psth_calc.m'
%                              cell: the cell number of PSTH
%                              bar:  the PSTH bar information, defined as an array of struct (2 fields, defined below)
%                                      bin: the number of PSTH bar
%                                      h:   the hight of PSTH bar
%                  cell_mod, defined as an array of struct (5 fields, defined below), generated by 'cell_mod_detn.m'
%                              cell:  the cell number of PSTH
%                              sr_0:  spike rate in the duration of 't_pre' before trigger
%                              sr_cs: spike rate in the duration of 't_post' after trigger
%                              diff:  defined as "sr_0 - sr_cs"
%                              type:  cell modulation type, "diff <= -5" -> facilitation, "diff >= 5" -> supression
%                  blk_spk,  defined as an array of struct (7 fields, defined below), generated by 'blk_spk_calc.m'
%                              cell:  the cell number of PSTH
%                              sr_0:  spike rate in the duration of 't_pre' before trigger
%                              sr_x:  array of spike rate in the bins inside duration of 't_post' after trigger
%                              amp_0: avarage of UR amplitude in the session
%                              amp_x: array of blink amplitude in the bins inside duration of 't_post' after trigger
%                              val_x: defined as "sr_x - sr_0"
%                              val_y: defined as "amp_x / amp_0"
% Function output: blk_pack, defined as an array of struct (4 fields, defined below)
%                              t:        trigger aligned timepoints
%                              cell_def: defined as an array of struct (3 fields, defined below)
%                                          nr:   cell number
%                                          type: cell type
%                                          mod:  cell modulation type. facilitation, supression, NO MOD
%                              blk_wfm:  defined as a 3 elements array of struct (2 fields, defined below)
%                                          type: trace type. cr = CR trials, no = Non-CR trials, all = all trials
%                                          tr:   values of the avaraged trace
%                              spk_wfm:  defined as an array of struct (2 fields, defined below)
%                                          nr:   cell number
%                                          tr:   values of the avaraged trace
%                              cell_reg: defined as an array of struct (7 fields, defined below)
%                                          nr:   cell number
%                                          r:    adjusted r-square value of regression model
%                                          p:    p value of regression model
%                                          h:    intercept of model
%                                          k:    slope of model
%                                          x:    x values, same as "blk_spk.val_x"
%                                          y:    y values, same as "blk_spk.val_y"

function blk_pack = dat_out_blk(filename,t_pre,cell_tp,blk,psth,mod,tas)
  t_pre = t_pre / 1000;

  % ------  CELL TYPE related data  ------
    cell_def(size(mod,2)) = struct('nr',[],'type',[]);
    for i = 1:size(mod,2)
        cell_def(i).nr = cell_tp(i).nr;
        cell_def(i).type = cell_tp(i).type;
        cell_def(i).mod_CR_trial = mod(i).type_CR;
        cell_def(i).mod_onset_CR_trial = mod(i).onset_CR;
        cell_def(i).mod_NO_CR = mod(i).type_NO_CR;
        cell_def(i).mod_onset_NO_CR = mod(i).onset_NO_CR;
        cell_def(i).mod_CS_ONLY = mod(i).type_CS_ONLY;
        cell_def(i).mod_onset_CS_ONLY = mod(i).onset_CS_ONLY;
    end
  
  % ------  EYEBLINK related data  ------
    BLK(3) = struct('type',[],'tr',[]);
    % CR traces
      blk_tr = [];
      n = 1;
      for i = 1:size(blk,2)
          blk(i).tr = blk(i).tr(1:50000);
          if ~isempty(blk(i).cr_on) && ~isempty(blk(i).ur_pk)
              blk_tr(:,n) = blk(i).tr;
              n = n + 1;
          end
      end
      BLK(1).type = 'CR';
      BLK(1).tr = mean(blk_tr,2);
      BLK(1).tr = BLK(1).tr(1:30000);
    % Non_CR traces 
      blk_tr = [];
      n = 1;
      for i = 1:size(blk,2)
          if isempty(blk(i).cr_on) && ~isempty(blk(i).ur_pk)
              blk_tr(:,n) = blk(i).tr;
              n = n + 1;
          else
          end
      end
      if ~isempty(blk_tr)
      BLK(2).type = 'NO_CR';
      BLK(2).tr = mean(blk_tr,2);
      BLK(2).tr = BLK(2).tr(1:30000);
      else
      BLK(2).type = 'No_CR';
      BLK(2).tr = [];
      BLK(2).tr = [];
      end
    % CS only trace
      blk_tr = zeros(size(blk(1).tr,1),size(blk,2)-size([blk.ur_pk],2));
      n = 1;
      for i = 1:size(blk,2)
          if isempty(blk(i).ur_pk)
              blk_tr(:,n) = blk(i).tr;
              n = n + 1;
          else
          end
      end
      if ~isempty(blk_tr)
      BLK(3).type = 'CS_ONLY';
      BLK(3).tr = mean(blk_tr,2);
      BLK(3).tr = BLK(3).tr(1:30000);
      else
      BLK(3).type = 'CS_ONLY';
      BLK(3).tr = [];
      BLK(3).tr = [];
      end
  % ------  TIME related data  ------
      fs = evalin('caller','frequency_parameters.amplifier_sample_rate');
      t_nr = size(blk_tr,1); 
      t_min = - t_pre;
      t_max = t_min + (t_nr - 1) / fs;
      t = transpose(round(linspace(t_min,t_max,t_nr),10));    % 'round' MUST be used to avoid strange residules

  % ------  PSTH related data  ------
      SPK(size(mod,2)) = struct('nr',[],'freq',[],'CR_trace',[],'NO_CR_trace',[],'CS_ONLY_trace',[],'CR_psth',[],'NO_CR_psth',[],'CS_ONLY_psth',[]);
      for i = 1:size(mod,2)
        % Smoothing frequency line
          freq_CR = linspace(min([psth(i).bar_CR.bin]),max([psth(i).bar_CR.bin]),30000);
          freq_tr_CR = interp1([psth(i).bar_CR.bin],[psth(i).bar_CR.h],freq_CR,'spline');
          if ~isempty(psth(i).bar_NO_CR)
              freq_NO_CR = linspace(min([psth(i).bar_NO_CR.bin]),max([psth(i).bar_NO_CR.bin]),30000);
              freq_tr_NO_CR = interp1([psth(i).bar_NO_CR.bin],[psth(i).bar_NO_CR.h],freq_NO_CR,'spline');
          else
              freq_NO_CR = [];
              freq_tr_NO_CR =[];
          end
          if ~isempty(psth(i).bar_CS_ONLY)
              freq_CS_ONLY = linspace(min([psth(i).bar_CS_ONLY.bin]),max([psth(i).bar_CS_ONLY.bin]),30000);
              freq_tr_CS_ONLY = interp1([psth(i).bar_CS_ONLY.bin],[psth(i).bar_CR.h],freq_CS_ONLY,'spline');
          else
              freq_CS_ONLY = [];
              freq_tr_CS_ONLY = [];
        % Arranging data
          SPK(i).nr = i;
          SPK(i).freq = mod(i).stat_CR.avg;
          SPK(i).CR_trace = freq_tr_CR;
          SPK(i).NO_CR_trace = freq_tr_NO_CR;
%           SPK(i).CS_ONLY_trace = freq_tr_CS_ONLY;
          SPK(i).CR_psth = psth(i).bar_CR;
          SPK(i).NO_CR_psth = psth(i).bar_NO_CR;
%           SPK(i).CS_ONLY_psth = psth(i).bar_CS_ONLY;
      end

  % ------  LINEAR REGRESSION data  ------
%       cell_reg(size(cell_mod,2)) = struct('nr',[],'r',[],'p',[],'h',[],'k',[],'x',[],'y',[]);
%       for i = 1:size(cell_mod,2)
%         % Processing linear regression
%           reg_mdl = fitlm(blk_spk(i).val_x,blk_spk(i).val_y);
%           reg_r = reg_mdl.Rsquared.Adjusted;
%           reg_p = reg_mdl.Coefficients.pValue(2);
%           reg_h = reg_mdl.Coefficients.Estimate(1);
%           reg_k = reg_mdl.Coefficients.Estimate(2);
%         % Arranging data
%           cell_reg(i).nr = i;
%           cell_reg(i).r = reg_r;
%           cell_reg(i).p = reg_p;
%           cell_reg(i).h = reg_h;
%           cell_reg(i).k = reg_k;
% 		  cell_reg(i).x = blk_spk(i).val_x;
% 		  cell_reg(i).y = blk_spk(i).val_y;
%       end
 

        TTT(size(mod,2)) = struct('nr',[],'tss_CR',[],'tss_NO_CR',[],'tss_CS_ONLY',[]);
        for i = 1:size(mod,2)
%         Arranging data
            TTT(i).nr = i;
            TTT(i).tss_CR = tas(i).tss_CR; 
            TTT(i).tss_NO_CR = tas(i).tss_NO_CR;
%             TTT(i).tss_CS_ONLY = tas(i).tss_CS_ONLY;
        end
 
  % ------ Saving data  ------
    blk_pack = struct('t',t,'cell_def',cell_def,'BLK',BLK,'SPK',SPK,'TTT',TTT);
    cd(pwd);
    filename = strcat(filename,'_blkpack','.mat');
    save(filename,'blk_pack');
end