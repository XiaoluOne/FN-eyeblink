% Calculate cell peristimulus time histogram (PSTH) and trigger aligned spikes (TAS), revised version 2.0.
% (c) Si-yang Yu @ PSI 2018

% Function input:  tas,     defined as an array of struct (2 fields, defined below), generated by 'psth.calc.m'
%                              cell:  the cell number of TAS
%                              tss:   the trigger separated spike (TSS) information, defined as an array of struct (2 fields, defined below)
%                                       trial: the number of related trial
%                                       t:     the spike timestamps within difined range of 't_pre' to 't_post', regards trigger timing
%                  t_range,  defined as an array of 2 elemets, range to be analized (ms)
% Function output: isi,      defined as an array of struct (2 fields, defined below)
%                              cell:  the cell number of ISI
%                              trial: the ISI information with each trial (2 fields, defined below)
%                                       nr:    the number of trial
%                                       isi:   the isi of trial                  

function isi = isi_info(tas,t_range,mod_tp)
    t_range = t_range / 1000;
    trial(size(tas(1).tss,2)) = struct('nr',[],'isi',[]);
    isi(size(tas,2)) = struct('cell',[],'trial',[]);
    for i = 1:size(tas,2)               % First loop, looping on cell, with indicator of i
        for j = 1:size(tas(i).tss,2)    % Second loop, looping on trial, with indicator of j
            temp = tas(i).tss(j).t;
            idx = temp > t_range(1) & temp <= t_range(2);
            t = temp(idx);
            idv_isi = zeros((size(t,1) - 1),1);
            for k = 1:(size(t,1) - 1)   % Third loop, looping on timestamp, with indicator of k
                idv_isi(k) = t(k + 1) - t(k);
            end
          % Arrange data
            trial(j).nr = tas(i).tss(j).trial;
            trial(j).isi = idv_isi;
        end
      % Arrange data
        isi(i).cell = tas(i).cell;
        isi(i).trial = trial;
    end
   
    
    %Xiaolu
    isi_cell = [];
    for i = 1:size(isi,2)
        for j = 1:size(isi(i).trial,2)
            isi_idv = isi(i).trial(j).isi;
            isi_cell = [isi_cell;isi_idv];
            isi_ln = log (isi_cell*1000); %natural logarithm of isi in ms
        end
        isi(i).isi_all = isi_cell;
        isi(i).cv = std(isi_cell)/mean(isi_cell);
        isi(i).isi_median = median(isi_cell); %result in s
        isi(i).cvln = std(isi_ln)/mean(isi_ln);
        isi(i).frequency = mod_tp(i).stat.avg;
    end
    
    
    
    
cv2 = []; %mean of twice the absolute difference of successive ISIs
          %divided by the sum of the two intervals
for i = 1:size(isi,2)
    for j = 1:(size(isi(i).isi_all,1)-1)
        isi_i = isi(i).isi_all(j);
        isi_ip1 = isi(i).isi_all(j+1);
        diff = abs(isi_i-isi_ip1);
        sum = isi_i+isi_ip1;
        cv2_i = 2*diff/sum;
        cv2 = [cv2;cv2_i];
    end
    cv2_mean = mean(cv2);
    isi(i).cv2_mean = cv2_mean;
end

for i = 1:size(isi,2)
    if isi(i).frequency>=30 && isi(i).frequency<=130 && isi(i).isi_median<0.02 && isi(i).cv2_mean>=0.2 && isi(i).cv2_mean<=0.9
        isi(i).ctp = 'PC';
    elseif isi(i).cvln<0.43 && isi(i).frequency>=2 && isi(i).frequency<=36
        isi(i).ctp = 'MIN';
    else
        isi(i).ctp = 'OUT';
    end
end

end