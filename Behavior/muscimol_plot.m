%downsize sampling points to 300
for i = 1:size(blk,2)
    new = [];
    for j = 1:300
        n = (j-1)*5+1;
        all = blk(i).tr(n:(5*j)); 
        all = mean(all);
        new = [new,all];
    end
    new = smooth(new); 
    blk(i).tr = new;
end

blk_trace = []; 
blk_sd = [];
for j = 1:300
    a = [];
    for i = 1:size(blk,2)
        a = [a;blk(i).tr(j)];
    end
    avr = mean(a);
    sd = std(a);
    blk_trace = [blk_trace;avr];
    blk_sd = [blk_sd;sd];
end
blk_up = blk_trace + blk_sd;
blk_down = blk_trace - blk_sd;

plot(blk_trace,'color','r')
hold on
plot(blk_up,'color','b')
hold on 
plot(blk_down,'color','b')