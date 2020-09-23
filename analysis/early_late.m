%delete Non_CR trials in CS_ttt
for i = 1:29
    a = [];
    for j = 1:size(PC(i).CS_ttt.tss_CR,2)
       if isempty(PC(i).CS_ttt.tss_CR(j).CR_on)
           a = [a;j];
       else 
       end
    end
    PC(i).CS_ttt.tss_CR(a) = [];
end

%make early_CR_onset and late_CR_onset array
PC_el = struct();
for i = 1:29
    %sorting based on CR_onset 
    t = struct2table(PC(i).CS_ttt.tss_CR);
    t = sortrows(t,'CR_on');
    PC(i).CS_ttt.tss_CR = table2struct(t);
    % generate PC_el struct including early and late trials information
    s = size(PC(i).CS_ttt.tss_CR,1);
    s = round(s/2);
        PC_el(i).nr = PC(i).nr;
        PC_el(i).early = PC(i).CS_ttt.tss_CR(1:s);
        PC_el(i).late = PC(i).CS_ttt.tss_CR(s:size(PC(i).CS_ttt.tss_CR,1));
        PC_el(i).early_CR_on = mean([PC_el(i).early(1:size(PC_el(i).early,1)).CR_on]);
        PC_el(i).late_CR_on = mean([PC_el(i).late(1:size(PC_el(i).late,1)).CR_on]);
end

bin_size = 10/1000;
bin_n = 1.5/bin_size;

%calculate bin and t fields
for i = 1:size(PC_el,2)
    PC_el(i).late_psth = [];
    for j = 1:bin_n
        PC_el(i).late_psth(j).bin = j;
        PC_el(i).late_psth(j).t = -0.5+j*bin_size;
    end
end 

for i = 1:size(PC_el,2) %PC_el loop
       for n = -0.5:bin_size:0.99
           a = 0;
           for j = 1:size(PC_el(i).late,1) %trial loop
               for k =1:size(PC_el(i).late(j).t,1) %spike even loop
                   if PC_el(i).late(j).t(k) >= n && PC_el(i).late(j).t(k) < n+bin_size
                       a = a+1;
                   else
                   end
               end
           end
           m = round((n+0.5)/0.01+1);
           PC_el(i).late_psth(m).h = a/bin_size/size(PC_el(i).late,1);
       end
end

%
for i=1:29
    spk_new = smooth([PC_el(i).late_psth(1:150).h]);
    bsl = spk_new(1:50);
    bsl_std = std(bsl);
    bsl_mean = mean(bsl);
    [cmod_pk, cmod_pkt] = max(spk_new(51:75)); %[500:625] for complex spike, [500:740] for simple spike
    PC_el(i).late_cmod_pkt = cmod_pkt*10; %remember plus (x-500)
end