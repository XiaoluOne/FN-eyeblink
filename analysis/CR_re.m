function cell = CR_re(cell)
%this function is used to notmalized eyeblid trace to maximum value 
aaa = [];
for j = 1:150
    cal = cell(j)/max(cell)*100;
    aaa = [aaa;cal];
end
cell = aaa;

end

