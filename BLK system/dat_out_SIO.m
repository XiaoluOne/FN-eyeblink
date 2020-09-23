% Calculate and save eyeblink related statistical values.


function blk_pack = dat_out_SIO(filename,t_pre,cell_tp,blk,psth,mod,tas)
  t_pre = t_pre / 1000;

  % ------  CELL TYPE related data  ------
    cell_def(size(mod,2)) = struct('nr',[],'type',[]);
    for i = 1:size(mod,2)
        cell_def(i).nr = cell_tp(i).nr;
        cell_def(i).type = cell_tp(i).type;
        cell_def(i).mod_paired = mod(i).type_paired;
        cell_def(i).mod_onset_paired = mod(i).onset_paired;
        cell_def(i).mod_opto = mod(i).type_opto;
        cell_def(i).mod_onset_opto = mod(i).onset_opto;
    end
  
  % ------  EYEBLINK related data  ------
    BLK(2) = struct('type',[],'tr',[]);
    % Paired traces
      blk_tr = [];
      n = 1;
      for i = 1:size(blk,2)
%           blk(i).tr = blk(i).tr(1:50000);
          if isequal(blk(i).type,'paired');
              blk_tr(:,n) = blk(i).tr;
              n = n + 1;
          else
          end
      end
      BLK(1).type = 'paired';
      BLK(1).tr = mean(blk_tr,2);
%       BLK(1).tr = BLK(1).tr(1:30000);
    % Opto traces 
      blk_tr = [];
      n = 1;
      for i = 1:size(blk,2)
          if isequal(blk(i).type,'opto');
              blk_tr(:,n) = blk(i).tr;
              n = n + 1;
          else
          end
      end
      BLK(2).type = 'opto';
      BLK(2).tr = mean(blk_tr,2);
%       BLK(2).tr = BLK(2).tr(1:30000);
    
  % ------  TIME related data  ------
      fs = evalin('caller','frequency_parameters.amplifier_sample_rate');
      t_nr = size(blk_tr,1); 
      t_min = - t_pre;
      t_max = t_min + (t_nr - 1) / fs;
      t = transpose(round(linspace(t_min,t_max,t_nr),10));    % 'round' MUST be used to avoid strange residules

  % ------  PSTH related data  ------
      SPK(size(mod,2)) = struct('nr',[],'freq',[],'paired_trace',[],'opto_trace',[],'paired_psth',[],'opto_psth',[]);
      for i = 1:size(mod,2)
        % Smoothing frequency line
          freq_paired = linspace(min([psth(i).bar_paired.bin]),max([psth(i).bar_paired.bin]),60000);
          freq_tr_paired = interp1([psth(i).bar_paired.bin],[psth(i).bar_paired.h],freq_paired,'spline');
          freq_opto = linspace(min([psth(i).bar_opto.bin]),max([psth(i).bar_opto.bin]),60000);
          freq_tr_opto = interp1([psth(i).bar_opto.bin],[psth(i).bar_opto.h],freq_opto,'spline');
        % Arranging data
          SPK(i).nr = i;
          SPK(i).freq = mod(i).stat_paired.avg;
          SPK(i).paired_trace = freq_tr_paired;
          SPK(i).opto_trace = freq_tr_opto;
          SPK(i).paired_psth = psth(i).bar_paired;
          SPK(i).opto_psth = psth(i).bar_opto;
      end

  % ------  TRIAL TO TRIAL REGRESSION data  ------

        TTT(size(mod,2)) = struct('nr',[],'tss_CR',[],'tss_NO_CR',[],'tss_CS_ONLY',[]);
        for i = 1:size(mod,2)
%         Arranging data
            TTT(i).nr = i;
            TTT(i).tss_P = tas(i).tss_P; 
            TTT(i).tss_O = tas(i).tss_O;
        end
 
  % ------ Saving data  ------
    blk_pack = struct('t',t,'cell_def',cell_def,'BLK',BLK,'SPK',SPK,'TTT',TTT);
    cd(pwd);
    filename = strcat('blkpack_',filename,'.mat');
    save(filename,'blk_pack');
end