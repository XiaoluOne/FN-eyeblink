
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
% for i = 1:size(PC_MO_MO,2)
%     for j = 1:size(PC_MO_MO(i).spk,1)
%             if isequal(PC_MO_MO(i).mod,'SUP')
%                 PC_MO_MO(i).spk(j) = PC_MO_MO(i).spk(j)/min(PC_MO_MO(i).spk)*100;
%             elseif isequal(PC_MO_MO(i).mod,'FAC')
%                 PC_MO_MO(i).spk(j) = PC_MO_MO(i).spk(j)/max(PC_MO_MO(i).spk)*100;
%             else
%             end
%     end
% end


%trial to trial correlation of different time-stamp of individual cell 
for n = 146:162
    if isequal(PC_MO(n).mod,'FAC') || isequal(PC_MO(n).mod,'SUP')
    hm = [];
    for i = 51:200 %(-250 to 500ms)
        for j = 51:200
            a = struct('spk',[],'blk',[],'trial',[]);
                for k = 1:size(PC_MO(n).ttt.tss_CR,2)
                    a(k).spk = PC_MO(n).ttt.tss_CR(k).spk(i);
                    a(k).blk = PC_MO(n).ttt.tss_CR(k).blk(j);
                    a(k).trial = PC_MO(n).ttt.tss_CR(k).trial;
                end
        %generate table for correlation
        t = struct2table(a);
        %linear model (cell and recording are random effects)
        reg = fitlm(t,'blk~spk');
        reg_r = reg.Rsquared.Adjusted;
        hm(j,i) = reg_r;
        t = table();
        end
    end
        PC_MO(n).hm = hm;
    else
    end
end


for i = 1:size(PC_MO,2) 
   PC_MO(i).hm =  PC_MO(i).hm(:,51:200);
   PC_MO(i).hm=  PC_MO(i).hm(51:200,:);

end
%calculation mean of r value of all cells
r_avr = [];
for i = 1:150 %(-250 to 500ms)
   for j = 1:150
      avr = [];
      for k = 1:size(PC_MO,2)
          if isequal(PC_MO(k).mod,'SUP')
              avr = [avr,PC_MO(k).hm_lm(i,j)];
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
a = heatmap(r_avr,'Colormap',newc);
a.GridVisible = 'off';
a.ColorLimits = [0.03,0.08];