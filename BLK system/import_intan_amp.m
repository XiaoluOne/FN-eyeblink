% Reads an amplifier data file and creates an electrode voltage (mV) struct array.
% (c) Si-yang Yu @ PSI 2018

% Function input:  amp_port, defined as the used port prefix for recording
% Function output: amp_sgn,  defined as an array of struct (2 fields, defined below)
%                              nr: the number of used channel
%                              v:  the votage signal of channel (mV)

function amp_sgn = import_intan_amp(amp_port)
    warning('off','backtrace');
  % Get related workspace data from caller
    try
        port_prefix = evalin('caller','[amplifier_channels.port_prefix]');
    catch
        port_prefix = [];
    end
  % Execution session
    if isempty(port_prefix)
      % Detect a recording session without amplifier data
        warning('No existing amplifier data found in header file!');
    else
      % Check and read the defined port data from recording session
        n_ch = size(find(port_prefix == amp_port),2);
        if n_ch ~= 0
            i = 0;
            amp_sgn(n_ch) = struct('nr',[],'v',[]);
            while i < n_ch
                file_nr = num2str(i,'%03d');
                file_name = strcat('amp-',amp_port,'-',file_nr,'.dat');
                if exist(file_name,'file')       
                  % Reads an amplifier data file and creates an electrode voltage vector (microvolts)
                    fileinfo = dir(file_name);
                    num_samples = fileinfo.bytes / 2;
                    fid = fopen(file_name,'r');
                    v = fread(fid,num_samples,'int16') * 0.195;  % value_type = 'int16'; mutiplier = 0.195 (mV)
                    fclose(fid);
                    amp_sgn(i+1) = struct('nr',i,'v',v);
                else
                  % Assign an empty value to missing / unused channel(s)
                    amp_sgn(i+1) = struct('nr',i,'v',[]);
                    warning(strcat('Channel No.',num2str(i,'%03d'),' on Port-',amp_port,' missing!'));
                end
                i= i + 1;
            end
        else
          % No recording channel(s) found
            amp_sgn = struct('nr',{},'v',{});
            warning(strcat('No recording data found on Port-',amp_port,'!'));
        end
    end
    warning('on','backtrace');
end