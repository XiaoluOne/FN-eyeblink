%calculate difference of normalized spike rate of paired and opto 
for i = 1:size(sio,2)
    diff = [];
    for j = 1:300
       diff(j) = sio(i).spk_opto(j)-sio(i).spk_paired(j); 
    end
    sio(i).diff = diff;
end

for i = 1:300
    a = [];
   for j = 1:size(sio,2)
      a = [a;sio(j).diff(i)];
   end
   avr(i) = mean(a);
end