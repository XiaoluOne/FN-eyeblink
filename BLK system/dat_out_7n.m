function blk_pack = dat_out_7n(filename,t_pre,cell_tp,blk,psth,cell_mod,tas)
  t_pre = t_pre / 1000;

  % ------  CELL TYPE related data  ------
    cell_def(size(cell_tp,2)) = struct('nr',[],'type',[],'mod',[]);
    for i = 1:size(cell_tp,2)
        cell_def(i).nr = i;
        cell_def(i).type = cell_tp(i).type;
        cell_def(i).mod = cell_mod(i).type;
    end
  

  % ------  TIME related data  ------
      fs = evalin('caller','frequency_parameters.amplifier_sample_rate');
      t_nr = 40000; %30k for eyeblink conditioning, 40k for spantaneous blink
      t_min = - t_pre;
      t_max = t_min + (t_nr - 1) / fs;
      t = transpose(round(linspace(t_min,t_max,t_nr),10));    % 'round' MUST be used to avoid strange residules

  % ------  PSTH related data  ------
      freq_wfm(size(cell_mod,2)) = struct('nr',[],'tr',[]);
      for i = 1:size(cell_mod,2)
        % Smoothing frequency line
          freq_x = linspace(min([psth(i).bar.bin]),max([psth(i).bar.bin]),t_nr);
          freq_tr = interp1([psth(i).bar.bin],[psth(i).bar.h],freq_x,'spline');
        % Arranging data
          freq_wfm(i).nr = i;
          freq_wfm(i).tr = freq_tr;
      end
% ------  EYEBLINK related data  ------
    BLK = struct('tr',[]);
    % Paired traces
      blk_tr = [];
      n = 1;
      for i = 1:size(blk,2)
%           blk(i).tr = blk(i).tr(1:50000);
              blk_tr(:,n) = blk(i).tr;
              n = n + 1;
      end
      BLK.tr = mean(blk_tr,2);
%       BLK.tr = BLK.tr(1:30000);

% ------  trial-to-trial related data  ------  
     TTT(size(cell_tp,2)) = struct('nr',[],'tss',[]);
        for i = 1:size(cell_tp,2)
%         Arranging data
            TTT(i).nr = i;
            TTT(i).tss = tas(i).tss; 
        end

  % ------ Saving data  ------
    blk_pack = struct('t',t,'cell_def',cell_def,'BLK',BLK,'SPK',freq_wfm,'TTT',TTT);
    cd(pwd);
    filename = strcat(filename,'_spblk','.mat');
    save(filename,'blk_pack');
end