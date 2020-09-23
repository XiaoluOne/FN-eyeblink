function [cell] = ttt_plot(cell)

%plot fitting curve for each cell
avr_int = [];
avr_slp = [];
for i = 1:size(cell,2)
    avr_int = [avr_int, cell(i).reg_int];
    avr_slp = [avr_slp, cell(i).reg_slp];
    x = cell(i).corr.spk';
    y = cell(i).reg_slp*x+cell(i).reg_int;
    if cell(i).reg_p < 0.05 && isequal(cell(i).mod,'FAC') && size(cell(i).corr,1) > 20 && cell(i).reg_slp < 0
        plot(x,y,'r','LineWidth',3);
    elseif cell(i).reg_p > 0.05 && isequal(cell(i).mod,'FAC') && cell(i).reg_slp < 0   
        plot(x,y,'color',[1,0.7,0.8],'LineWidth',3);
    else     
    end
   hold on
end

end
