
bin_n = (1:5);
bin_size = histcounts([opto.onset],5);
xq = (1:0.1:5);
v = interp1(bin_n,bin_size,xq,'spline');
histogram([opto.onset],16);
hold on
plot(v);
