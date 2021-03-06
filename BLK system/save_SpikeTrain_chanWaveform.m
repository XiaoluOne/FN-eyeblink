% Import SpikeTrain chanWaveform class data file
% (c) Si-yang Yu @ PSI 2018

% Function input: obj_name, name of chanEvent data in workspace
%                 var_name, name of desired workspace variable name

function save_SpikeTrain_chanWaveform(obj_name,var_name)
    eval([var_name,'=obj_name.data.adc;']);
        assignin('caller',var_name,obj_name.data.adc);
    path_name = pwd;
        file_path = strcat(path_name,'\',var_name,'.mat');
    save(file_path,var_name);
end