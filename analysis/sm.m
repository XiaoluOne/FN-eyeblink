function cell = sm(cell)

%smooth spk as 300 points
for i = 1:size(cell,2)
    new = [];
    for j = 1:300
        n = (j-1)*100+1;
        all = cell(i).spk.CR_trace(n:(100*j));
%         all = cell(i).spk(n:(100*j)); %for opto 
        all = mean(all);
        new = [new,all];
    end
    new = smooth(new); 
    cell(i).spk.CR_trace = new;
%     cell(i).spk = new; %for opto
end

%smooth blk trace as 300 points
for i = 1:size(cell,2)
    new = [];
    for j = 1:300
        n = (j-1)*100+1;
        all = cell(i).blk(1).tr(n:(100*j));
        all = mean(all);
        new = [new,all];
    end 
    cell(i).blk(1).tr = new;
end

%normalize spk with mean (for ttt)
for i = 1:size(cell,2)
   a = cell(i).spk.CR_trace(1:100);
%    a = cell(i).spk(1:100);%for opto
   for j = 1:300
       cal = cell(i).spk.CR_trace(j)/mean(a)*100;
%        cal = cell(i).spk(j)/mean(a)*100;
%        cell(i).spk(j) = cal;
       cell(i).spk.CR_trace(j) = cal;
   end
end

%normalize spk with zscore (for heat_map)
% for i = 1:size(cell,2)
%    [~,avr,std] = zscore(cell(i).spk(1:100)); 
%    for j = 1:300
%        cal = (cell(i).spk(j)-avr)/std;
%        cell(i).spk(j) = cal;
%    end
% end

%normalize CR to 100% UR
for i = 1:size(cell,2)
    cell(i).blk(1).tr = CR_re(cell(i).blk(1).tr);
end

end

