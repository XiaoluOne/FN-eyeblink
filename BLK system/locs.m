function [non_cr_locs,cs_only_locs,Clocs] = locs(blk,cs_lc)
%generate CS location for all trials
all_locs = struct('nr',[],'t',[]);
for i = 1:size(cs_lc,1)
    all_locs(i).nr = i;
    all_locs(i).t = cs_lc(i);
end

%find CS locations of non_CR trial (non_cr_locs) and CS_only trials(cs_only_locs)
non_cr_locs = struct('nr',[],'t',[]);
cs_only_locs = struct('nr',[],'t',[]);
Clocs = struct('nr',[],'t',[]);
n = 1;
m = 1;
p = 1;
for i = 1:size(blk,2)
   if isempty(blk(i).cr_on) && ~isempty(blk(i).ur_pk) %non_CR CS+US trials
       non_cr_locs(n).nr = i;
       non_cr_locs(n).t = all_locs(i).t;
       n = n+1;
   elseif isempty(blk(i).ur_pk) %CS_only trials 
       cs_only_locs(m).nr = i;
       cs_only_locs(m).t = all_locs(i).t;
       m = m+1;
   elseif ~isempty(blk(i).cr_on) && ~isempty(blk(i).ur_pk) %CR CS+US trials
       Clocs(p).nr = i;
       Clocs(p).t = all_locs(i).t;
       p = p+1;
   else
   end
end


end

