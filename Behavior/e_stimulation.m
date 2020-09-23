clear
% Import Intan header and path
  read_Intan_RHD2000_file;
  cd(path);
% Import Intan time vectors
  t = import_intan_time;
  t = fix_intan_time(t);
% Import Intan ADC channels vector
  adc = import_intan_adc([]);
% Trigger detection
  n = find_trg_pks([adc(1).v],1.5,t,1);
  trigger = [];
  for i = 2:size(n,1)
     a = n(i)-n(i-1);
     if a>0.1
         trigger = [trigger,n(i)-0.4];
     else
     end
  end
% Filter eyeblink trace
  v = idv_filter([adc(2).v],1,200,0,0,0,0);
% Detect eyeblink 
blk = struct();
for i = 1:size(trigger,2) 
    n = trigger(i)*20000;
    b = n-0.5*20000; e = n+20000-1;
    trace = v(b:e);
    blk(i).trial = i;
    blk(i).blk = trace;
end
save('7mV-IN_200402_173344','blk');