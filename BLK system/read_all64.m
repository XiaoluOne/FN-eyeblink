%edited subplot by Gao 19082017 
function [swf,adc] = read_all64;




% parameters input
amp_port = 'A';
no_ch = 64;
apply_lp = 0;
lp_freq = 1500;
apply_hp = 0;
hp_freq = 300;
apply_notch = 0;
notch_freq = 50 ;

% reads an Intan RHD2000 header file
read_Intan_RHD2000_file;

% reads a timestamp data file and creates a time vector (miliseconds)
fileinfo = dir('time.dat');
num_samples = fileinfo.bytes/4;
fid = fopen('time.dat', 'r');
t = fread(fid, num_samples, 'int64');
fclose(fid);
t = t / 20000*1000;

% read all 64 channels
i = 1;
    while i <= 64;
    file_no = num2str(i-1, '%03d');
    file_name = strcat('amp-', amp_port, '-', file_no, '.dat');

        if exist(file_name, 'file')       
        % reads an amplifier data file and creates an electrode voltage vector (microvolts)
        fileinfo = dir(file_name);
        num_samples = fileinfo.bytes/2;
        fid = fopen(file_name, 'r');
        v = fread(fid, num_samples, 'int16');
        fclose(fid);
        v = v * 0.195;
 

        % filter functions
             if apply_lp == 1
            fNorm_low = lp_freq / (frequency_parameters.amplifier_sample_rate/2);
            [b_low,a_low] = butter(10, fNorm_low, 'low');
            v = filtfilt(b_low, a_low, v);
            end;
             if apply_hp == 1
            fNorm_high = hp_freq / (frequency_parameters.amplifier_sample_rate/2);
            [b_high,a_high] = butter(3, fNorm_high, 'high');
            v = filt(b_high, a_high, v);
            end;
            if apply_notch == 1   
            fNorm_notch = notch_freq / (frequency_parameters.amplifier_sample_rate/2);
            notch_bandw = fNorm_notch / 10;
            [b_notch, a_notch] = iirnotch(fNorm_notch, notch_bandw);
            v = filtfilt(b_notch, a_notch, v);
            end;
        
     vtg {i} = v; 
         end
    i=i+1;
    end;
                                            % subtract a common average
spikewaveformsraw = cell2mat(vtg);%covert to matrix


swf = bsxfun(@minus, spikewaveformsraw, nanmean(spikewaveformsraw,2));



%load behavior and trigger traces
j = 1;
        while j <= 8;
    file_no = num2str(j-1, '%02d');
    file_name = strcat('board-ADC-', file_no, '.dat');

                if exist(file_name, 'file')       
        % reads an amplifier data file and creates an electrode voltage vector (microvolts)
        fileinfo = dir(file_name);
        num_samples = fileinfo.bytes/2;
        fid = fopen(file_name, 'r');
        v = fread(fid, num_samples, 'int16');
        fclose(fid);
        trigger{j} = v;
                 end;
        j=j+1;
        end;
        

%covert to matrix

adc = cell2mat (trigger);  

%make subplots of each channel
    f = figure;
            for k = 1:64;    
            data = swf(:,k);
        %subaxis(6, 12, k, 'sh', 0.01, 'sv', 0.01, 'padding0.01', 0, 'margin', 0.01);
            subplot(6,12,k);
            plot(t(240000:245000),data(240000:245000));
            set(gca,'xtick',[],'YLim',[-500 500]);
            set(gcf, 'Position', [150, 150, 2400, 1200]);
            legend (num2str(k));
            end
     
end
