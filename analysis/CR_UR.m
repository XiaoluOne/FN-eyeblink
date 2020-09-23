for i =1:15
    bsl = mean([FN(i).spk.CR_psth(1:50).h]);
    if isequal(FN(i).mod,'NOM')
        FN(i).cmod_pk = 0;
    elseif isequal(FN(i).mod,'SUP')
        FN(i).cmod_pk = (min([FN(i).spk.CR_psth(110:150).h])-bsl)/bsl*100;
    else
        FN(i).cmod_pk = (max([FN(i).spk.CR_psth(110:150).h])-bsl)/bsl*100;
    end
    
    if isequal(FN(i).umod,'FAC') 
        FN(i).umod_pk = (max([FN(i).spk.CR_psth(150:170).h])-bsl)/bsl*100;
    elseif isequal(FN(i).umod,'SUP') 
        FN(i).umod_pk = (min([FN(i).spk.CR_psth(150:170).h])-bsl)/bsl*100;
    else
        FN(i).umod_pk = 0;
    end
end

% for i =1:162
%     bsl = mean([FN(i).spk.CR_psth(1:50).h]);
%     if isequal(FN(i).mod,'NOM')
%         FN(i).cmod_pk = 0;
%     elseif isequal(FN(i).mod,'SUP')
%         FN(i).cmod_pk = min([FN(i).spk.CR_psth(50:75).h])-bsl;
%     else
%         FN(i).cmod_pk = max([FN(i).spk.CR_psth(50:75).h])-bsl;
%     end
%     
%     if isequal(FN(i).umod,'FAC')
%         FN(i).umod_pk(CR0) = max([FN(i).spk.CR_psth(76:85).h])-bsl;
%     else isequal(FN(i).mod,'SUP')
%         FN(i).umod_pk(CR0) = min([FN(i).spk.CR_psth(76:85).h])-bsl;
%     end
% end
