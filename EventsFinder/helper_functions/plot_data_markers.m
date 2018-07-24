function plot_data_markers(app,name,start_time,eda_time,eda,eda_sqi,hr_time,hr,temp_time,temp,temp_sqi,markers,event_type,color)
%PLOT_DATA_MARKERS Plot physiological data from Participant and/or
%Caregiver. Includes Markers as asterisks and SQI on the top of the
%graph.
%{
assignin('base','eda_time',eda_time);
assignin('base','eda',eda);
assignin('base','eda_sqi',eda_sqi);

assignin('base','hr_time',hr_time);
assignin('base','hr',hr);

assignin('base','temp_time',temp_time);
assignin('base','temp',temp);
assignin('base','temp_sqi',temp_sqi);

assignin('base','app',app);
assignin('base','name',name);
assignin('base','start_time',start_time);
assignin('base','markers',markers);
assignin('base','event_type',event_type);
assignin('base','color',color);
%}
%% Selecting Raw Data for Heart Rate Variability Measures
    if(strcmp(name,'Participant'))
        hr_raw = app.HR_p{:,2};
    else
        hr_raw = app.HR_c{:,2};
    end
    hr_raw = str2double(hr_raw);

    if(strcmp(name,'Participant'))
        hr_time_raw = app.HR_p{:,1};
    else
        hr_time_raw = app.HR_c{:,1};
    end
    hr_time_raw = str2double(hr_time_raw);
%% Correct time values
disp('Correcting start time');
% Use formula: newvariablename = (variablename - start time)/1000
eda_time_corr = (eda_time-start_time)/1000;
hr_time_corr = (hr_time-start_time)/1000;
temp_time_corr = (temp_time-start_time)/1000;
hr_time_raw = (hr_time_raw-start_time)/1000;

%% Find time markers generated by Events app
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

data_1 = eda_markers;
for i = 1:length(eda_markers)
    eda_poss_time = eda_time_corr(eda_time_corr > eda_markers(i)); %choose all times greater than integer
    eda_poss_time = eda_time_corr(eda_time_corr == eda_poss_time(1,1),1); %find smallest exact time
    eda_poss_time = find(eda_time_corr == eda_poss_time(1,1)); %index of exact time
    data_1(1,i)= eda_poss_time;
end
eda_marker_times = eda_time_corr(data_1);
eda_marker_values = eda(data_1); %y value corresponding to exact time

data_2 = hr_markers;
for i = 1:length(hr_markers)
hr_poss_time = hr_time_corr(hr_time_corr > hr_markers(i)); %choose all times greater than integer
hr_poss_time = hr_time_corr(hr_time_corr == hr_poss_time(1,1),1); %find smallest exact time
hr_poss_time = find(hr_time_corr == hr_poss_time(1,1)); %index of exact time
data_2(1,i)= hr_poss_time;
end
hr_marker_times = hr_time_corr(data_2);
hr_marker_values = hr(data_2); %y value corresponding to exact time

data_3 = temp_markers;
for i = 1:length(temp_markers)
    temp_poss_time = temp_time_corr(temp_time_corr > temp_markers(i)); %choose all times greater than integer
    temp_poss_time = temp_time_corr(temp_time_corr == temp_poss_time(1,1),1); %find smallest exact time
    temp_poss_time = find(temp_time_corr == temp_poss_time(1,1)); %index of exact time
    data_3(1,i)= temp_poss_time;
end
temp_marker_times = temp_time_corr(data_3);
temp_marker_values = temp(data_3); %y value corresponding to exact time
                
%% Plot Physiological Data
disp('Plotting data subplots');
title = strcat(name,' Physiological Data'); 
figure('Name',title)
RGB = [27/255 0/255 135/255]; %marker color

eda_subplot = subplot(3,1,1);
%Modify SQI
eda_sqi=(max(eda)+0.5)+eda_sqi; 
%Plot EDA Subplot
hold on
plot(eda_time_corr,eda,color);
plot(eda_time_corr,eda_sqi,'color',[153/255 153/255 255/255]);
if (~isempty(eda_markers)) %insert markers from events app
    (scatter(eda_marker_times,eda_marker_values,30,RGB,'*')); 
end
grid on
hold off
%Axis Properties
ylim([1 4]);
ylabel('EDA');
xticks(0:100:2700);
xtickangle(45);

hr_subplot = subplot(3,1,2);
%Plot HR Subplot
hold on
plot(hr_time_raw,hr_raw,'color',[210/255 210/255 210/255])
plot(hr_time_corr,hr,color)
grid on
if (~isempty(hr_markers)) %insert markers from events app
    (scatter(hr_marker_times,hr_marker_values,30,RGB,'*'));
end 
hold off
%Axis Properties
ylabel('HR'); 
xticks(0:100:2700);
xtickangle(45);

temp_subplot = subplot(3,1,3); 
%Modify SQI 
temp_sqi = (max(temp)+0.5)+temp_sqi;
%Plot Temp Subplot 
hold on
plot(temp_time_corr,temp,color);
plot(temp_time_corr,temp_sqi,'color',[153/255 153/255 255/255]);
if (~isempty(temp_markers)) %insert markers from app
   (scatter(temp_marker_times,temp_marker_values,30,RGB,'*')); 
end
grid on
hold off
%Axis Properties
xlabel('Time(s)');
ylabel('Temp(C)'); 
ylim([34 36]);
xticks(0:100:2700);
xtickangle(45);

%Additional Axis Properties
linkaxes([eda_subplot,hr_subplot,temp_subplot],'x');
xlim([120 inf]);

disp('Program complete!');
end