
%select modulating cells
% n = 1;
% for i = 1:size(PC,2)
%    if isequal(PC(i).mod,'FAC') || isequal(PC(i).mod,'SUP') 
%        PC_MO(n) = PC(i);
%        n = n+1;
%    else isequal(PC(i).mod,'NOM') 
%    end
% end

% %standardazition spk of SUP and FAC (trial to trial base) only for
% intr-cell correlation
% for i = 1:size(PC_MO,2)
%     for j = 1:size(PC_MO(i).ttt,2)
%         for k = 1: size(PC_MO(i).ttt(j).spk,1)
%             if isequal(PC_MO(i).mod,'SUP')
%                 PC_MO(i).ttt(j).spk(k) = PC_MO(i).ttt(j).spk(k)/min(PC_MO(i).ttt(j).spk)*100;
%             elseif isequal(PC_MO(i).mod,'FAC')
%                 PC_MO(i).ttt(j).spk(k) = PC_MO(i).ttt(j).spk(k)/max(PC_MO(i).ttt(j).spk)*100;
%             else
%             end
%         end
%     end
% end

% %standardazition spk of SUP and FAC (psth base) only for
% intr-cell correlation
% for i = 1:size(PC_MO,2)
%     for j = 1:size(PC_MO(i).spk,1)
%             if isequal(PC_MO(i).mod,'SUP')
%                 PC_MO(i).spk(j) = PC_MO(i).spk(j)/min(PC_MO(i).spk)*100;
%             elseif isequal(PC_MO(i).mod,'FAC')
%                 PC_MO(i).spk(j) = PC_MO(i).spk(j)/max(PC_MO(i).spk)*100;
%             else
%             end
%     end
% end


%trial to trial correlation of different time-stamp of individual cell 
hm = [];
for n = 102:103
for i = 51:200 %(-250 to 500ms)
    for j = 51:200
        a = struct('spk',[],'blk',[],'trial',[]);
%         for n = 1:size(PC_MO,2) 
            for k = 1:size(FN_MO(n).ttt.tss_CR,2)
                a(k).spk = FN_MO(n).ttt.tss_CR(k).spk(i);
                a(k).blk = FN_MO(n).ttt.tss_CR(k).blk(j);
                a(k).trial = FN_MO(n).ttt.tss_CR(k).trial;
            end
%         end
        %generate table for correlation
%         t = struct2table(a);
        %linear mix-effect model (cell and recording are random effects)
          x = transpose([a.spk]);
          y = transpose([a.blk]);
          padX = [ones(length(x),1) x];
          linPara = padX \ y;
          yCalc = padX * linPara;
          reg_r = 1 - sum((y - yCalc).^2) / sum((y - mean(y)).^2);
%         reg = fitlm(t,'blk~spk+trial');
%         reg_r = reg.Rsquared.Adjusted;
          hm(j,i) = reg_r;
%         t = table();
    end
end
FN_MO(n).heat_sy = hm;
end


for i = 1:size(FN_MO,2)
   FN_MO(i).heat_sy =  FN_MO(i).heat_sy(:,51:200);
   FN_MO(i).heat_sy =  FN_MO(i).heat_sy(51:200,:);
end

%calculation mean of r value of all cells
r_avr = [];
for i = 1:150 %(-250 to 500ms)
   for j = 1:150
      avr = [];
      for k = 1:size(FN_MO,2)
          if isequal(FN_MO(k).mod,'FAC')
              avr = [avr,FN_MO(k).heat_sy(i,j)];
          else
          end 
      end
      avr = mean(avr);
      r_avr(i,j) = avr;
   end
end

%heatmap plot
cmap = colormap(1-hot);
newc = [];
for i = 1:64
    newc(i,:) = cmap((65-i),:);
end
a = heatmap(r_avr,'Colormap',hot);
a.GridVisible = 'off';
a.ColorLimits = [0.03 0.07];