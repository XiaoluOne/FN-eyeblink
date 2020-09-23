% This program is used for spliting the csv file after spike sorting. The
% seperation time as an input should be generated when you merge the data
% file from different recordings.  --Zhong


clear;
conversion_time=read_sep_timepoint('sep.csv');
% csv_name='._H2DBC_3.1-64.csv';
csv_origin=csvread('._H2DBC_3.1-64.csv') ;
% csv_origin=[csv_origin session];
first_t=0;


for n=1:length(conversion_time)-1
    last_t=find(csv_origin(:,1)<=conversion_time(n+1,1) & csv_origin(:,1)>conversion_time(n,1),1,'last');
    csv_origin(first_t+1:last_t,1)=csv_origin(first_t+1:last_t,1)-conversion_time(n,1);
    dlmwrite([num2str(n) '.csv'] ,csv_origin((first_t+1):last_t,:),'precision','%.5f');
%     csv_origin((first_t+1):(last_t),4)=n;
    
    first_t=last_t;
end






function conversion_time=read_sep_timepoint(sep_csv_file)
         
time_points=csvread(sep_csv_file);
  conversion_time=zeros(size(time_points,2)+1,1);
  for k=1:size(time_points,2)
      time=time_points(1,k);
      conversion_time(k+1,1)=conversion_time(k,1)+time;
  end
end

