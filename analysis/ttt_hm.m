%find outlier trials(trial number in a)
trial = table2array(FN_all(1).corr);
trial(:,1:2) = [];
n = 1;
a = [];
for i = 1:35
   if FN_all(1).ttt.tss_CR(i).trial == trial(n)
       n = n+1;
   else
       a = [a;i];
   end
end

%manual delete trials in ttt fiels (trial number in a)
%copy corr.spk, past in ttt.CR_on
%manual sort trials by CR_on amplitude in ttt table

blk = [];
spk = [];
for i = 1:22
   blk = [blk;FN_all(1).ttt.tss_CR(i).blk'];
   spk = [spk;FN_all(1).ttt.tss_CR(i).spk'];
end
spk = spk;

blk = blk(:,90:159);
spk = -spk(:,90:159);

%heatmap plot
cmap = colormap(1-hot);
newc = [];
for i = 1:64
    newc(i,:) = cmap((65-i),:);
end
%CR
a = heatmap(blk,'Colormap',newc);
a.GridVisible = 'off';
a.ColorLimits = [5,50];
%spk
a = heatmap(spk,'Colormap',newc);
a.GridVisible = 'off';
a.ColorLimits = [0,35];