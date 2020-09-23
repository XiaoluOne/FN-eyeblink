%function  importIntanData
%IMPORTRAMKISDATA Summary of this function goes here
%   Detailed explanation goes here

% u: select data
%fileType = {'*.rhd', 'SpikeTrain-Files (*.abf)';...
    %'*.*', 'All files (*.*)'};
    function intan2spd (varargin)
        
    swf = varargin{1};
    adc = varargin{2};
    
    %if ~isscalar(spikewaveforms) || ~isscalar(ADC)
       % error('No vector inputs detected. Exiting.');
   % end
    
    %for chn=3:nargin
        %do something
        %spikewaveforms(:, varargin{chn})
    %end
    
    data = dataPkg.data;

    %for i = 1:numFile
   
   
    % make wave continous
  % numDP = length(spikewaveforms(:,1));
  % numSweeps = 1;
  % numChan = 5;
   %lenSweep = numDP*(50/1000000);
   % fs = 1/(50/1000000);
  
  
    for a= 3:nargin; 
        chn=varargin{a}; 
    % create new file 
    
    waves = reshape(swf(:,chn),[],1);
        % new waveform channel n
        settings.vector = waves;
        settings.title = ['chan', num2str(chn)];
        settings.comment = ' ';
        settings.fs = 20000;
        settings.dataType = 'vector';
        settings.chanType = 'waveform';
        data.newChannel(settings);
    end
 
    
% new waveform eyeblink  

    trig1 = abs(adc(:,1)/10000);
    settings.vector = trig1;
    settings.title = 'eyeblink';
    settings.comment = '';
    settings.fs = 20000;
    settings.dataType = 'vector';
    settings.chanType = 'waveform';
    data.newChannel(settings);          
%CS trigger    
    trig2 = abs(adc(:,2)/10000);
    settings.vector = trig2;
    settings.title = 'CS';
    settings.comment = '';
    settings.fs = 20000;
    settings.dataType = 'vector';
    settings.chanType = 'waveform';
    data.newChannel(settings);       
 
    %Opto
%     trig3 = abs(adc(:,3)/10000);
%     settings.vector = trig3;
%     settings.title = 'Opto';
%     settings.comment = '';
%     settings.fs = 20000;
%     settings.dataType = 'vector';
%     settings.chanType = 'waveform';
%     data.newChannel(settings); 
    
    
    % u: select location
filePath = uigetdir;
% save files
  
    fileLocation = fullfile(filePath, 'all.spd');
    data.saveDataAs(fileLocation);
    end  