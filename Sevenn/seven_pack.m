
%------------------generate package of all session--------------------------

clear
%generate package of each cell type
list = dir('*.mat');
seven_all = struct();
n=0;
for i = 1:size(list,1)
    file_name = list(i).name;
    load (file_name,'-mat');
    for j = 1:size(seven_pack,2)
        n = n+1;
        seven_all(n).nr = n;
        seven_all(n).name = file_name;
        seven_all(n).cell_nr = seven_pack(j).nr;
        seven_all(n).blk = seven_pack(j).blk;
        seven_all(n).mod = seven_pack(j).mod;
        seven_all(n).spk = seven_pack(j).spk;
        seven_all(n).ttt = seven_pack(j).ttt;
%         seven_all(n).corr = seven_pack(j).corr;
%         seven_all(n).reg_r = seven_pack(j).reg_r;
%         seven_all(n).reg_p = seven_pack(j).reg_p;
%         seven_all(n).reg_int = seven_pack(j).reg_int;
%         seven_all(n).reg_slp = seven_pack(j).reg_slp;
    end
end
