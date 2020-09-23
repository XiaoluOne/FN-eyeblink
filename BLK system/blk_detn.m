% Process eyeblink traces and detect CR and UR with standard criteria.
% (c) Si-yang Yu @ PSI 2018

% Function input:  eye_tr,   raw eyeblink trace
%                  rec_t,    recording timestamps
%                  cs_lc,    CS onset time points, should be generated from CS trace by 'find_trg_pks.m'
%                  us_lc,    US onset time points, should be generated from US trace by 'find_trg_pks.m'
%                  t_pre,    pre-trigger time to be analyzed (ms)
%                  t_post,   post-trigger time to be analyzed (ms)
%                  t_probe,  Probe (CS only) trial CR detection time (ms)
%                  dur,      per experiment session duration (ms)
% Function output: blk_data, defined as an array of struct (9 fields, defined below)
%                              tr:      baseline adjusted eyeblink trace
%                              t:       session timestamps
%                              cr_on:   CR onset time
%                              cr_pk:   CR peak time
%                              cr_amp:  CR peak amplitude
%                              eff_pk:  US onset time when CR onset exist
%                              eff_amp: eyelid amplitude at US onset time 
%                              ur_pk:   UR peak time
%                              ur_amp:  UR peak amplitude

function blk_dat = blk_detn(eye_tr,rec_t,cs_lc,us_lc,t_pre,t_post,t_probe,dur)
    t_pre = t_pre / 1000;
    t_post = t_post / 1000;
    t_probe = t_probe / 1000;
    dur = dur / 1000;
    us_lc(size(us_lc,1) + 1) = max(rec_t);
    blk_dat(size(cs_lc,1)) = struct('tr',[],'t',[],'cr_on',[],'cr_pk',[],'cr_amp',[],'eff_pk',[],'eff_amp',[],'ur_pk',[],'ur_amp',[]);
    i = 1;
    j = 1;
    while i <= size(cs_lc,1)
      % Define baseline and threshold
        idx = (rec_t >= round(cs_lc(i) - t_pre,10)) & (rec_t < cs_lc(i));
        bln = mean(eye_tr(idx));       % Baseline defined as avarage of pre-trial eyelid amplitude
        bth = 3 * std(eye_tr(idx));    % Threshold = 3 * baseline
      % Process eye trace CR
        idx = (rec_t >= round(cs_lc(i),10)) & (rec_t < cs_lc(i) + t_post);
        v_tr = bln - eye_tr(idx);
        t_tr = rec_t(idx);
        cr_0 = find(v_tr > bth,1);    % CR amplitude MUST> threshold
        if isempty(cr_0)
            cr_on = [];
            cr_amp = [];
            cr_pk = [];
            cr_to_ur = 0;
        else
            cr_on = t_tr(cr_0);
            if us_lc(j) < (cs_lc(i) + dur)    % Find probe trial
                idx = (rec_t > cr_on) & (rec_t < cs_lc(i) + t_post);
            else
                idx = (rec_t > cr_on) & (rec_t < cs_lc(i) + t_probe);
            end
            v_tr = bln - eye_tr(idx);
            t_tr = rec_t(idx);
            [cr_amp,cr_1] = max(v_tr);
            cr_pk = t_tr(cr_1);
            cr_to_ur = cr_amp;
        end
      % Process eye trace UR and EFF
        if us_lc(j) < (cs_lc(i) + dur)    % Excluding probe trial
            idx = (rec_t >= round(us_lc(j),10)) & (rec_t < us_lc(j) + t_post);
            v_tr = bln - eye_tr(idx);
            t_tr = rec_t(idx);
            [ur_amp,ur_1] = max(v_tr);
          % Get effective eyelid info
            eff_pk = [];
            if isempty(cr_0)
                eff_pk = [];
                eff_amp = [];
            else
                eff_pk = us_lc(j);
                eff_amp = v_tr(1);
            end
          % Get UR data
            if (ur_amp < cr_to_ur) || (ur_amp < 1.5 * bth)    % UR amplitude MUST> cr_amp, MUST> 1.5 * CR threshold
                ur_amp = [];
                ur_pk = [];
            else
                ur_pk = t_tr(ur_1);
            end
            j = j + 1;
        else
            ur_amp = [];
            ur_pk = [];
        end
      % Arrange data
        idx = (rec_t >= round(cs_lc(i) - t_pre,10)) & (rec_t < cs_lc(i) + dur);
        trial_tr = bln - eye_tr(idx);    % Baseline definition (bln = LOCAL BASELINE)
        trial_t = rec_t(idx);
         blk_dat(i) = struct('tr',trial_tr,'t',trial_t,'cr_on',cr_on,'cr_pk',cr_pk,'cr_amp',cr_amp,'eff_pk',eff_pk,'eff_amp',eff_amp,'ur_pk',ur_pk,'ur_amp',ur_amp);
%          blk_dat(i) = struct('tr',trial_tr,'t',trial_t,'cr_on',cr_on,'cr_pk',cr_pk,'cr_amp',cr_amp);
        i = i + 1;
    end
end