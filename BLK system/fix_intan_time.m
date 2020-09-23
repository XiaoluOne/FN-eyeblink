% Fix the time duplication issue from Intan RHD2000 recordings
% (c) Si-yang Yu @ PSI 2018

% Function input:  t_in,  Intan RHD2000 timestamp array
% Function output: t_out, output timestamp array

function t_out = fix_intan_time(t_in)
    warning('off','backtrace');
    if size(t_in,1) == size(unique(t_in),1)
        t_out = t_in;
    else
        warning('Timestamp sequence duplication issue found!');
        t_nr = size(t_in,1);
        fs = evalin('caller','frequency_parameters.amplifier_sample_rate');
        t_min = min(t_in);
        t_max = t_min + (t_nr - 1) / fs;
        t_out = transpose(round(linspace(t_min,t_max,t_nr),10));    % 'round' MUST be used to avoid strange residules
    end
    warning('on','backtrace');
end