function plot_data_markers(name,start_time,eda_time,eda,eda_sqi,hr_time,hr,temp_time,temp,temp_sqi,markers,event_type,color)
%PLOT_DATA_MARKERS Summary of this function goes here
%   Detailed explanation goes here
%% Correct time values
disp('Correcting start time');
% Use formula: newvariablename = (variablename - start time)/1000
eda_time_corr = (eda_time-start_time)/1000;
hr_time_corr = (hr_time-start_time)/1000;
temp_time_corr = (temp_time-start_time)/1000;

%% Find time markers associated with each data type
eda_markers = [];
hr_markers = [];
temp_markers = [];
for i = 1:length(event_type)
    if(event_type(i) == 1)
        %eda
        eda_markers = [eda_markers,markers(i)];
    elseif(event_type(i) == 2)
       %hr
       hr_markers = [hr_markers,markers(i)];
    else
        %temp
        temp_markers = [temp_markers,markers(i)];
    end
end
%% Plot Caregiver Physiological Data
disp('Plotting data subplots');
title = strcat(name,' Physiological Data'); 
figure('Name',title);
eda_subplot = subplot(3,1,1);
plot(eda_time_corr,eda, color);
if (length(eda_markers)~=0)
    c_h_eda = vline(eda_markers,'k:'); %insert markers
end
ylabel('EDA');
xticks(0:250:2500);

hr_subplot = subplot(3,1,2);
plot(hr_time_corr,hr, color);
if (length(hr_markers)~=0)
    c_h_hr = vline(hr_markers,'k:'); %insert markers
end 
ylabel('HR');
xticks(0:250:2500);

temp_subplot = subplot(3,1,3);
plot(temp_time_corr,temp, color);
if (length(temp_markers)~=0)
    c_h_temp = vline(temp_markers,'k:'); %insert markers
end
ylabel('Temp (C)');
xticks(0:250:2500);

linkaxes([eda_subplot,hr_subplot,temp_subplot],'x');
xlim([120 inf]);

%% Compare moving average vs median filter on temperature
hold(eda_subplot, 'on');
eda_subplot2 = subplot(3,1,1);
eda_sqi=(min(eda)-1)+eda_sqi;
plot(eda_time_corr,eda_sqi);
hold(eda_subplot, 'off');

hold(temp_subplot, 'on');
temp_subplot2 = subplot(3,1,3);
temp_sqi = (min(temp)-1)+temp_sqi;
plot(temp_time_corr,temp_sqi);
hold(temp_subplot, 'off');

disp('Program complete!');
end

