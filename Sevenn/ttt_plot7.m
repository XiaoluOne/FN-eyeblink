%plot fitting curve for each seven_all
int = [];
slp = [];
for i = 1:18
    int = [int, seven_all(i).reg_int];
    slp = [slp, seven_all(i).reg_slp];
    x = seven_all(i).corr.spk';
    y = seven_all(i).reg_slp*x+seven_all(i).reg_int;
    if isequal(seven_all(i).testrun_mod,'FAC') && seven_all(i).reg_slp < 0
        plot(x,y,'r','LineWidth',3);
    elseif isequal(seven_all(i).testrun_mod,'SUP') && seven_all(i).reg_slp < 0  
        plot(x,y,'color','b','LineWidth',3);
    else     
    end
   hold on
end