% Plotting eyeblink traces with CR/UR marks for HUMAN verification.
% (c) Si-yang Yu @ PSI 2018

% Function input: rec_t,    recording timestamps
%                 blk_data, defined as an array of struct (9 fields, defined below)
%                             tr:      baseline adjusted eyeblink trace
%                             t:       session timestamps
%                             cr_on:   CR onset time
%                             cr_pk:   CR peak time
%                             cr_amp:  CR peak amplitude
%                             eff_pk:  US onset time when CR onset exist
%                             eff_amp: eyelid amplitude at US onset time 
%                             ur_pk:   UR peak time
%                             ur_amp:  UR peak amplitude

function blk_plot(t_rec,blk_dat)
    figure('Name','Eyeblink Traces','NumberTitle','off')
  % Plotting baselin of ZERO for reference
    zrln = zeros(round(max(t_rec)));
    plot(zrln,'Color',[0.5 0.5 0.5],'LineWidth',1);
  % Plotting baseline adjusted eyeblink traces
    i = 1;
    while i <= size(blk_dat,2)
        hold on
            plot([blk_dat(i).t],[blk_dat(i).tr],'Color',[0.0000 0.4470 0.7410]);
        i = i + 1;
    end
  % Plotting CR onset time, marked as CIRCLE
    hold on
        plot ([blk_dat.cr_on],0,'o','MarkerEdgeColor','k','MarkerSize',8);
  % Plotting CR peak, marked as GREEN CROSS
    hold on
        plot([blk_dat.cr_pk],[blk_dat.cr_amp],'x','MarkerEdgeColor',[0.2941 0.4353 0.2667],'MarkerSize',8);
  % Plotting Effective CR peak, marked as RED CROSS
    hold on
        plot([blk_dat.eff_pk],[blk_dat.eff_amp],'x','MarkerEdgeColor',[0.5373 0.0000 0.0941],'MarkerSize',8);
  % Plotting UR peak, marked as ASTERISK
    hold on
        plot([blk_dat.ur_pk],[blk_dat.ur_amp],'*','MarkerEdgeColor',[0.7686 0.1176 0.2275],'MarkerSize',8);
  % Set labels
    xlabel('Time (s)');
    ylabel('Blink Amplitude');
end