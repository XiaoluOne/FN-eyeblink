%caculate mean of cell's spike rate and eyeblink trace 


function cell_plot = cs_ss_plot(cell_tp,cell_nr)

cell_plot = struct('CR_all',[],'CR_fac',[],'CR_sup',[],'CR_nom',[],'spk_all',[],'spk_fac',[],'spk_sup',[],'spk_nom',[]);
cr = []; spk = [];
%calculate mean of all cell's spike rate and eyeblink trace respectively
for i = 1:cell_nr
    cr = [cr;cell_tp(i).blk(1).tr'];
    spk = [spk;cell_tp(i).spk.CR_trace'];
end
cell_plot.CR_all = mean(cr);
cell_plot.spk_all = mean(spk);

%calculate mean of facilitating and supressing cell's spike rate and mean eyeblink
%trace respectively
cell_fac_spk = []; cell_sup_spk = []; cell_nom_spk = [];
cell_fac_cr = []; cell_sup_cr = []; cell_nom_cr = [];

for i = 1:cell_nr
if isequal(cell_tp(i).mod,'FAC')
    cell_fac_spk = [cell_fac_spk;cell_tp(i).spk.CR_trace];
    cell_fac_cr = [cell_fac_cr;cell_tp(i).blk(2).tr'];
elseif isequal(cell_tp(i).mod,'SUP')  
    cell_sup_spk = [cell_sup_spk;cell_tp(i).spk.CR_trace];
    cell_sup_cr = [cell_sup_cr;cell_tp(i).blk(2).tr'];
else
    cell_nom_spk = [cell_nom_spk;cell_tp(i).spk.CR_trace];
    cell_nom_cr = [cell_nom_cr;cell_tp(i).blk(2).tr'];
end
end
cell_plot.spk_fac = mean(cell_fac_spk);
cell_plot.spk_sup = mean(cell_sup_spk);
cell_plot.spk_nom = mean(cell_nom_spk);
cell_plot.CR_fac = mean(cell_fac_cr);
cell_plot.CR_sup = mean(cell_sup_cr);
cell_plot.CR_nom = mean(cell_nom_cr);
    
end



