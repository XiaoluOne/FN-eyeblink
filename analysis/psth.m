function [cell] = psth(cell,bin_size)
%bin_size should be in ms 

bin_size = bin_size/1000;
bin_n = 1.5/bin_size;

%calculate bin and t fields
for i = 1:size(cell,2)
    cell(i).spk.IN_opto = [];
    for j = 1:bin_n
        cell(i).spk.IN_opto(j).bin = j;
        cell(i).spk.IN_opto(j).t = -0.5+j*bin_size;
    end
end 

for i = 1:size(cell,2) %cell loop
       for n = -0.5:bin_size:0.99
           a = 0;
           for j = 1:size(cell(i).ttt.IN_opto,2) %trial loop
               for k = 1:size(cell(i).ttt.IN_opto(j).t,1) %spike even loop
                   if cell(i).ttt.IN_opto(j).t(k) >= n && cell(i).ttt.IN_opto(j).t(k) < n+bin_size
                       a = a+1;
                   else
                   end
               end
           end
%            m = round((n+0.5)/0.005+1);
           m = round((n+0.5)*100+1);
           cell(i).spk.IN_opto(m).h = a/bin_size/size(cell(i).ttt.IN_opto,2);
       end
end


end

