%find outlier trials(trial number in a)
% trial = table2array(seven_all(1).corr);
% trial(:,1:2) = [];
% n = 1;
% a = [];
% for i = 1:55
%    if seven_all(1).ttt.testrun(i).trial == trial(n)
%        n = n+1;
%    else
%        a = [a;i];
%    end
% end

%manual delete trials in ttt fiels (trial number in a)
%copy corr.spk, past in ttt.CR_on
%manual sort trials by CR_on amplitude in ttt table

blk = [];
spk = [];
for i = 1:48
   blk = [blk;seven_all(1).ttt.testrun(i).blk'];
   spk = [spk;seven_all(1).ttt.testrun(i).spk'];
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
figure(1)
a = heatmap(blk,'Colormap',hot);
a.GridVisible = 'off';
a.ColorLimits = [20,100];
%spk
figure(2)
a = heatmap(spk,'Colormap',hot);
a.GridVisible = 'off';
a.ColorLimits = [-5,40];