

%------------------generate package of individual session--------------------------

clear
%generate package of each cell type
list = dir('*.mat');

seven = struct();

for i = 1:size(list,1)
    file_name = list(i).name;
    load (file_name,'-mat');
    seven(i).name = file_name;
    seven(i).cell_def = blk_pack.cell_def;
    seven(i).blk = blk_pack.BLK;
    seven(i).spk = blk_pack.SPK;
    seven(i).ttt = blk_pack.TTT;
end

