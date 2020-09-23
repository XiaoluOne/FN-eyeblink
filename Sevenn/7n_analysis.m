%calculate spike rate in CR trials and non-CR trials 
for i = 1:81
    spk_blk0 = [];
    spk_blk1 = [];
    for j = 1:size(seven_all(i).ttt.testrun,2)
        if isempty(seven_all(i).ttt.testrun(j).blk_on)
            spk_blk0 = [spk_blk0;seven_all(i).ttt.testrun(j).spk_tr'];
        else
            spk_blk1 = [spk_blk1;seven_all(i).ttt.testrun(j).spk_tr'];  
        end
        seven_all(i).spk_blk0 = mean(spk_blk0);
        seven_all(i).spk_blk1 = mean(spk_blk1);
        
    end
end

%normalize spk_blk0/1 to baseline
for i=1:62
%     seven_all(i).spk_norm.testrun = [];
%     seven_all(i).spk_norm.FN_opto = [];
%     seven_all(i).spk_norm.IN_opto = [];
    seven_all(i).spk_norm.testrun = [seven_all(i).spk.testrun(1:150).h]/mean([seven_all(i).spk.testrun(1:50).h])*100;
    seven_all(i).spk_norm.FN_opto = [seven_all(i).spk.FN_opto(1:150).h]/mean([seven_all(i).spk.FN_opto(1:50).h])*100;
    seven_all(i).spk_norm.IN_opto = [seven_all(i).spk.IN_opto(1:150).h]/mean([seven_all(i).spk.IN_opto(1:50).h])*100;
end

%calculate firing rate during cs for each cell
for i = 1:55
    seven_all(i).fr_blk0_norm = mean(seven_all(i).spk_blk0_norm(110:140));
    seven_all(i).fr_blk1_norm = mean(seven_all(i).spk_blk1_norm(110:140));
end

%subplot
for i=1:30
    subplot(5,6,i)
    plot(seven_all(i).blk.testrun,'b')
    hold on 
    plot(seven_all(i).blk.IN_opto,'r')
    hold on
    plot(seven_all(i).blk.FN_opto,'g')
    hold on
    title(i)
end

%calculate firing rate during CS in testrun, FN_opto and IN_opto
%UR 751:950, CR 601:750
for i = 1:60
    seven_all(i).testrun_fr = mean(seven_all(i).spk_norm.testrun(601:750));
    seven_all(i).FN_fr = mean(seven_all(i).spk_norm.FN_opto(601:750));
    seven_all(i).IN_fr = mean(seven_all(i).spk_norm.IN_opto(601:750));
end 

%normalize traces base on the average baseline of 3 conditions 
for i =1:62
   bsl = [seven_all(i).spk.testrun(1:500);seven_all(i).spk.FN_opto(1:500);seven_all(i).spk.IN_opto(1:500)];
   seven_all(i).spk_norm.testrun = seven_all(i).spk.testrun/mean(bsl)*100;
   seven_all(i).spk_norm.FN_opto = seven_all(i).spk.FN_opto/mean(bsl)*100;
   seven_all(i).spk_norm.IN_opto = seven_all(i).spk.IN_opto/mean(bsl)*100;
end

for i = 1:35
   subplot(6,6,i)
   plot(seven_all(i).spk_norm.testrun,'color','b')
   hold on
   plot(seven_all(i).spk_norm.FN_opto,'color','r')
   hold on
   plot(seven_all(i).spk_norm.IN_opto)
   hold on
   title(seven_all(i).nr)
end
% selection
for i = 1:60
   if seven_all(i).testrun_fr>seven_all(i).FN_fr && seven_all(i).testrun_fr > seven_all(i).IN_fr
       seven_all(i).selection = 1;
   else
       seven_all(i).selection = 0;
   end
end

for i = 1:26
    if isequal(seven_all(i).selection,1) && seven_all(i).FN_ufr > seven_all(i).IN_ufr
        a = seven_all(i).blk.FN_opto;
        b = seven_all(i).blk.IN_opto;
        seven_all(i).blk.FN_opto = b;
        seven_all(i).blk.IN_opto = a;
        a = seven_all(i).spk.FN_opto;
        b = seven_all(i).spk.IN_opto;
        seven_all(i).spk.FN_opto = b;
        seven_all(i).spk.IN_opto = a;
        a = seven_all(i).spk_norm.FN_opto;
        b = seven_all(i).spk_norm.IN_opto;
        seven_all(i).spk_norm.FN_opto = b;
        seven_all(i).spk_norm.IN_opto = a;
    else 
    end
        
end

for i = 45:60
    if seven_all(i).FN_ufr > seven_all(i).IN_ufr
        a = seven_all(i).blk.FN_opto;
        b = seven_all(i).blk.IN_opto;
        seven_all(i).blk.FN_opto = b;
        seven_all(i).blk.IN_opto = a;
        a = seven_all(i).spk.FN_opto;
        b = seven_all(i).spk.IN_opto;
        seven_all(i).spk.FN_opto = b;
        seven_all(i).spk.IN_opto = a;
        a = seven_all(i).spk_norm.FN_opto;
        b = seven_all(i).spk_norm.IN_opto;
        seven_all(i).spk_norm.FN_opto = b;
        seven_all(i).spk_norm.IN_opto = a;
    else 
    end
        
end

