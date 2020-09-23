%generate PC struct including both complex spike and simple spike info
PC = struct('nr',[],'recording_ID',[],'blk',[],'spk',[],'SS_ttt',[],'CS_ttt',[],'mod',[],'CR_on',[],'SS_on',[],'SS',[],'SS_ttt_p',[]);
%spk indicates complex spike, mod indicates simple spike modulation
for i = 1:size(PC_cpx,2)
    for j = 1:size(PC_ss,2)
        if isequal(PC_cpx(i).recording_ID,PC_ss(j).recording_ID) && PC_cpx(i).SS_nr == PC_ss(j).SS_nr
            PC(i).nr = i;
            PC(i).recording_ID = PC_cpx(i).recording_ID;
            %blink info
            PC(i).CR_on = PC_ss(j).CR_on;
            PC(i).CR_pkt = PC_ss(j).CR_pkt;
            PC(i).UR_pkt = PC_ss(j).UR_pkt;
            PC(i).blk = PC_cpx(i).blk;
            %simple spike info
            PC(i).mod = PC_ss(j).mod;
            PC(i).SS_on = PC_ss(j).mod_on;
            PC(i).SS = PC_ss(j).spk;
            PC(i).SS_ttt_p = PC_ss(j).reg_p;
            %complex spike info
            PC(i).CSC_mod = PC_cpx(i).mod;
            PC(i).CSU_mod = PC_cpx(i).umod;
            PC(i).spk = PC_cpx(i).spk;
            PC(i).cmod_pkt = PC_cpx(i).cmod_pkt;
            PC(i).umod_pkt = PC_cpx(i).umod_pkt;
            PC(i).SS_ttt = PC_ss(j).ttt;
            PC(i).CS_ttt = PC_cpx(i).ttt;
            
        else  
        end
    end
end