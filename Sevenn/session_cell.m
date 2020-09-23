seven_pack = struct('nr',[],'blk',[],'mod',[],'spk',[],'ttt',[]);

for i = 1:size(seven,2)
    for j = 1:size(seven(i).spk,2)
        seven_pack(j).nr = j;
        if isequal(seven(i).cell_def(j).type,'testrun')
            seven_pack(j).blk.testrun = seven(i).blk;
            seven_pack(j).spk.testrun = seven(i).spk(j).tr;
            seven_pack(j).ttt.testrun = seven(i).ttt(j).tss;
%             seven_pack(j).corr = seven(i).ttt(j).corr;
%             seven_pack(j).reg_r = seven(i).ttt(j).reg_r;
%             seven_pack(j).reg_p = seven(i).ttt(j).reg_p;
%             seven_pack(j).reg_int = seven(i).ttt(j).reg_int;
%             seven_pack(j).reg_slp = seven(i).ttt(j).reg_slp;
            seven_pack(j).mod.testrun = seven(i).cell_def(j).mod;
        elseif isequal(seven(i).cell_def(j).type,'FN_opto_bl')
            seven_pack(j).blk.opto = seven(i).blk;
            seven_pack(j).spk.opto = seven(i).spk(j).tr;
            seven_pack(j).ttt.opto = seven(i).ttt(j).tss;
            seven_pack(j).mod.opto = seven(i).cell_def(j).mod;
        elseif isequal(seven(i).cell_def(j).type,'FN_opto')
            seven_pack(j).blk.testrun_opto = seven(i).blk;
            seven_pack(j).spk.testrun_opto = seven(i).spk(j).tr;
            seven_pack(j).ttt.testrun_opto = seven(i).ttt(j).tss;
            seven_pack(j).mod.testrun_opto = seven(i).cell_def(j).mod;
%         elseif isequal(seven(i).cell_def(j).type,'FN_opto_bl')
%             seven_pack(j).blk.FN_opto_bl = seven(i).blk;
%             seven_pack(j).spk.FN_opto_bl = seven(i).spk(j).tr;
%             seven_pack(j).ttt.FN_opto_bl = seven(i).ttt(j).tss;
%             seven_pack(j).mod.FN_opto_bl = seven(i).cell_def(j).mod;
%         elseif isequal(seven(i).cell_def(j).type,'IN_opto_bl')
%             seven_pack(j).blk.IN_opto_bl = seven(i).blk;
%             seven_pack(j).spk.IN_opto_bl = seven(i).spk(j).tr;
%             seven_pack(j).ttt.IN_opto_bl = seven(i).ttt(j).tss;
%             seven_pack(j).mod.IN_opto_bl = seven(i).cell_def(j).mod;
        else
        end
    end
end

filename = '16600-01_test3';
save(filename,'seven_pack');

