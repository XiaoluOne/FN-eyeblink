%plot all FAC cells with ttt p<0.05
% for i=1:18
%     figure(i)
%     plot(FN(i).spk_norm.testrun)
% end

%
trace = [];
for i = 1:19
%     if ~isempty(IN(i).opto)
        trace = [trace;seven_all(i).spk_norm.FN_opto'];
%     else 
%     end
end
spk_avr = mean(trace);
sd = std(trace);
sem = [];
for i = 1:1500
    sem = [sem,sd(i)/sqrt(19)];
end

curve_up = spk_avr + sem;
curve_down = spk_avr - sem;

spk_avr = seven_shorten(spk_avr,1500,300);
curve_up = seven_shorten(curve_up,1500,300);
curve_down = seven_shorten(curve_down,1500,300);

plot(smooth(spk_avr))
hold on
plot(smooth(curve_up))
hold on
plot(smooth(curve_down))

