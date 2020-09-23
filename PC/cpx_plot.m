%caculate mean of cell's spike rate and eyeblink trace of complex spikes


function cell_plot = cpx_plot(cell_tp,cell_nr)

cell_plot = struct('CR_all',[],'CR_fac',[],'CR_nom',[],'spk_all',[],'spk_fac',[],'spk_nom',[]);
cr = []; spk = [];
%calculate mean of all cell's spike rate and eyeblink trace respectively
for i = 1:cell_nr
    cr = [cr;cell_tp(i).blk(1).tr'];
    spk = [spk;cell_tp(i).spk.CR_trace];
end
cell_plot.CR_all = mean(cr);
cell_plot.spk_all = mean(spk);

%calculate mean of facilitating and supressing cell's spike rate and mean eyeblink
%trace respectively
cell_fac_spk = []; cell_nom_spk = [];
cell_fac_cr = []; cell_nom_cr = [];

for i = 1:cell_nr
if isequal(cell_tp(i).mod,'FAC')
    cell_fac_spk = [cell_fac_spk;cell_tp(i).spk.CR_trace];
    cell_fac_cr = [cell_fac_cr;cell_tp(i).blk(1).tr'];
else
    cell_nom_spk = [cell_nom_spk;cell_tp(i).spk.CR_trace];
    cell_nom_cr = [cell_nom_cr;cell_tp(i).blk(1).tr'];
end
end
cell_plot.spk_fac = mean(cell_fac_spk);
cell_plot.spk_nom = mean(cell_nom_spk);
cell_plot.CR_fac = mean(cell_fac_cr);
cell_plot.CR_nom = mean(cell_nom_cr);

%shorten and smooth all traces too 300
    a = []; b = []; c = []; d = [];
    e = []; f = []; g = []; h = [];
    for j = 1:300
        n = (j-1)*100+1;
        spk_all = cell_plot.spk_all(n:(100*j));
        spk_all = mean(spk_all);
        a = [a,spk_all];
        spk_fac = cell_plot.spk_fac(n:(100*j));
        spk_fac = mean(spk_fac);
        b = [b,spk_fac];
        spk_nom = cell_plot.spk_nom(n:(100*j));
        spk_nom = mean(spk_nom);
        d = [d,spk_nom];
        CR_all = cell_plot.CR_all(n:(100*j));
        CR_all = mean(CR_all);
        e = [e,CR_all];
        CR_fac = cell_plot.CR_fac(n:(100*j));
        CR_fac = mean(CR_fac);
        f = [f,CR_fac];
        CR_nom = cell_plot.CR_nom(n:(100*j));
        CR_nom = mean(CR_nom);
        h = [h,CR_nom];
    end
    cell_plot.spk_all = smooth(a); 
    cell_plot.spk_fac = smooth(b);
    cell_plot.spk_nom = smooth(d);
    cell_plot.CR_all = smooth(e); 
    cell_plot.CR_fac = smooth(f);
    cell_plot.CR_nom = smooth(h);
    
end



