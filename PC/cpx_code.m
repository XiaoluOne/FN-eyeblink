
cpx = cs_ss_plot(PC,16);

cpx.spk_fac = [];
sd_all = [];
co_all = [];
for j = 1:300
    cal = [];
    for i = 1:size(PC,2)   
          idv = PC(i).spk.CR_trace(j);
          cal = [cal,idv];

    end
    avr = mean(cal);
    cpx.spk_fac(j) = avr;
    %calculate SD of each time point, preparing for plotting
    sd = std(cal);
    co = sd/avr*100;
    co_all = [co_all;co];
    sd_all = [sd_all;sd];
end
cpx.spk_fac = cpx.spk_fac';
curve_up = cpx.spk_fac + co_all;
curve_down = cpx.spk_fac - co_all;

%plot
figure(1);
% hold on
% plot (time,amp,'.','MarkerEdgeColor','b','MarkerSize',30); %onset plot
hold on
plot (cpx.spk_fac,'Color',[0.8,0.35,0.35],'LineWidth',3);
hold on 
plot (curve_up,'r','LineWidth',1);
hold on
plot (curve_down,'r','LineWidth',1);