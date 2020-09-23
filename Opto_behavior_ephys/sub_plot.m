  for i=1:24
    figure(i)
    subplot(1,2,1)
    plot(sio(i).spk_paired)
    subplot(1,2,2)
    plot(sio(i).spk_opto)
  end

  for i = 1:24
      subplot(4,6,i)
      plot(opto(i).trace)
  end