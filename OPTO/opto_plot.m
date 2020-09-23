
%caculate mean of cell's spike rate and eyeblink trace 


function cell_plot = opto_plot(cell_tp,cell_nr)
cell_plot = struct('CR_all',[],'CR_fast',[],'CR_slow',[],'CR_nom',[],'spk_all',[],'spk_fast',[],'spk_slow',[],'spk_nom',[]);
cr = []; spk = [];
%calculate mean of all cell's spike rate and eyeblink trace respectively
for i = 1:cell_nr
    cr = [cr;cell_tp(i).blk(1).tr'];
    spk = [spk;cell_tp(i).spk];
end
cell_plot.CR_all = mean(cr);
cell_plot.spk_all = mean(spk);

%calculate mean of facilitating and supressing cell's spike rate and mean eyeblink
%trace respectively
cell_fast_spk = []; cell_slow_spk = []; cell_nom_spk = [];
cell_fast_cr = []; cell_slow_cr = []; cell_nom_cr = [];

for i = 1:cell_nr
if isequal(cell_tp(i).mod,'FAST')
    cell_fast_spk = [cell_fast_spk;cell_tp(i).spk];
    cell_fast_cr = [cell_fast_cr;cell_tp(i).blk(1).tr'];
elseif isequal(cell_tp(i).mod,'SUP')  
    cell_slow_spk = [cell_slow_spk;cell_tp(i).spk];
    cell_slow_cr = [cell_slow_cr;cell_tp(i).blk(1).tr'];
else
    cell_nom_spk = [cell_nom_spk;cell_tp(i).spk];
    cell_nom_cr = [cell_nom_cr;cell_tp(i).blk(1).tr'];
end
end
cell_plot.spk_fast = mean(cell_fast_spk);
cell_plot.spk_slow = mean(cell_slow_spk);
cell_plot.spk_nom = mean(cell_nom_spk);
cell_plot.CR_fast = mean(cell_fast_cr);
cell_plot.CR_slow = mean(cell_slow_cr);
cell_plot.CR_nom = mean(cell_nom_cr);

%smooth
    a = []; b = []; c = []; d = [];
    for j = 1:300
        n = (j-1)*100+1;
        spk_all = cell_plot.spk_all(n:(100*j));
        spk_all = mean(spk_all);
        a = [a,spk_all];
        spk_fast = cell_plot.spk_fast(n:(100*j));
        spk_fast = mean(spk_fast);
        b = [b,spk_fast];
        spk_slow = cell_plot.spk_slow(n:(100*j));
        spk_slow = mean(spk_slow);
        c = [c,spk_slow];
        spk_nom = cell_plot.spk_nom(n:(100*j));
        spk_nom = mean(spk_nom);
        d = [d,spk_nom];
    end
    a = smooth(a); 
    cell_plot.spk_all = a;
    b = smooth(b); 
    cell_plot.spk_fast = b;
    c = smooth(c); 
    cell_plot.spk_slow = c;
    d = smooth(d); 
    cell_plot.spk_nom = d;
end



