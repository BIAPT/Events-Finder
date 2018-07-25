function [event_struct,hr_struct,temp_struct,sc_struct] = find_events(app,type)
%FIND_EVENTS % Find the events for a participant or a caregiver and return them
%   Input
%   app: contain the application public data
%   type: p = participant, c = care-giver
%   
%   Output
%   event_struct: structure containing selected events information (event
%   and type)
%   hr_struct,temp_struct,sc_struct: structure containing time and average
%   of all three modalities

    %% Creating Returned Variables
    event_struct = struct();
    event_struct.events = [];
    event_struct.type = [];
    
    hr_struct = struct();
    hr_struct.time = [];
    hr_struct.avg = [];

    temp_struct = struct();
    temp_struct.time = [];
    temp_struct.avg = [];
    temp_struct.avg_sqi = [];
    
    sc_struct = struct();
    sc_struct.time = [];
    sc_struct.avg = [];
    sc_struct.avg_sqi = [];

    %% Creating and Setting Other Variables
    start_time = app.start_time;
    end_time = get_end_time(app,type);
    win_size = 500;
    
    events = struct();
    events.eda.time = [];
    events.eda.diff = [];
    events.hr.time = [];
    events.hr.diff = [];
    events.temp.time = [];
    events.temp.diff = [];
    
    % get the right threshold depending on participant or a care-giver
    if(strcmp(type,'p'))
        curr_thresh = app.thresholds.p;
    elseif(strcmp(type,'c'))
        curr_thresh = app.thresholds.c;
    end

    
    %% Average the Signals
    % Get the averaged values for each data type
    [hr_averaged,hr_time,bad_hr_time,~] = get_average(app,type,'hr',win_size,r_start_time,end_time);
    [temp_averaged,temp_time,bad_temp_time,temp_averaged_sqi] = get_average(app,type,'temp',win_size,r_start_time,end_time);
    [eda_averaged,eda_time,bad_eda_time,eda_averaged_sqi] = get_average(app,type,'eda',win_size,r_start_time,end_time);

    %% Averaging and Filtering
    %(EDA) Apply Moving Average Filter
    eda_averaged = moving_average(eda_averaged,15)';
    
    %(HR) Apply Moving Average Filter
    %{
    hr_averaged = movingaverage_2(hr_averaged,55)';
    hrDelay = (55-1)/2;
    hr_time = hr_time-hrDelay;
    %}
    %Cubic spline function
    p=0.001; %0 to 1, where 0 is maximal smoothing
    hr_averaged = csaps(hr_time,hr_averaged,p,hr_time);
    
    %(TEMP) Apply Exponential Decay Filter on Temperature
    temp_averaged = expdecay(temp_averaged,0.80);

    %% Find Bad Time Points
    % Concatenate the bad times for TEMP and EDA and take only the non redondant ones
    bad_time = unique([bad_temp_time;bad_eda_time]);

    %% (HR) Events Detection
     if(app.HRCheckBox.Value == 1)
        % An event is tagged if there is a prominent peak (default 10 bpm)
        [hr_peak_val,hr_peak_idx,~,hr_peak_prom] = findpeaks(hr_averaged,'MinPeakProminence',curr_thresh.hr); 
        hr_peak_time = hr_time(hr_peak_idx);
        %Find Valleys
        hr_inverted = -hr_averaged;
        [hr_valley_val,hr_valley_idx,~,hr_valley_prom] = findpeaks(hr_inverted,'MinPeakProminence',curr_thresh.hr);
        hr_valley_time = hr_time(hr_valley_idx);
        %Concatenate Times and Prominences
        events.hr.alltime = vertcat(hr_peak_time,hr_valley_time);
        hr_allprom = vertcat(hr_peak_prom,hr_valley_prom);
        %Find times that are not bad times
        counter=1;
        for i = 1:(size(events.hr.alltime))
            if (~ismember(events.hr.alltime(i,1),bad_time))
                events.hr.time(counter,1)=events.hr.alltime(i,1);
                counter=counter+1;
            end
        end
        %Find prominences associated to good marker times
        [~,hr_log] = ismember(events.hr.alltime,events.hr.time);
        hr_prom = hr_allprom(find(hr_log));
        %Find differences
        hr_change = hr_prom-curr_thresh.hr;
        events.hr.diff = [events.hr.diff; hr_change];
        %Convert time to seconds
        events.hr.time = (events.hr.time-r_start_time)/1000;
     end
    
    %% (SC) Events Detection
    if(app.EDACheckBox.Value == 1)
       % An event is tagged if there is a given change in a 10 second interval (default about 0.1 microsemens)
       offset = 10/0.5;
       for i = 1:(size(eda_time,1)-offset)
           eda_change = abs(eda_averaged(i+offset,1) - eda_averaged(i,1)) ;
           if(eda_change > curr_thresh.eda && ~ismember(eda_time(i,1),bad_time))
               events.eda.time = [events.eda.time; (eda_time(floor(i+offset/2),1)-r_start_time)/1000];
               events.eda.diff = [events.eda.diff; eda_change/curr_thresh.eda];
           end
       end
    end   
    
    %% (TEMP) Events Detection
    if(app.TempCheckBox.Value == 1)
        % An event is tagged if there is a prominent peak (default 0.1 degree)
        [temp_peak_val,temp_peak_idx,~,temp_peak_prom] = findpeaks(temp_averaged,'MinPeakProminence',curr_thresh.temp); 
        temp_peak_time = temp_time(temp_peak_idx);
        %Find Valleys
        temp_inverted = -temp_averaged;
        [temp_valley_val,temp_valley_idx,~,temp_valley_prom] = findpeaks(temp_inverted,'MinPeakProminence',curr_thresh.temp);
        temp_valley_time = temp_time(temp_valley_idx);
        %Concatenate Times and Prominences
        events.temp.alltime = vertcat(temp_peak_time,temp_valley_time);
        temp_allprom = vertcat(temp_peak_prom,temp_valley_prom);
        %Find times that are not bad times
        counter=1;
        for i = 1:(size(events.temp.alltime))
            if (~ismember(events.temp.alltime(i,1),bad_time))
                events.temp.time(counter,1)=events.temp.alltime(i,1);
                counter=counter+1;
            end
        end
        %Find prominences associated to good marker times
        [~,temp_log] = ismember(events.temp.alltime,events.temp.time);
        temp_prom = temp_allprom(find(temp_log));
        %Find differences
        temp_change = temp_prom-curr_thresh.temp;
        events.temp.diff = [events.temp.diff; temp_change];
        %Convert time to seconds
        events.temp.time = (events.temp.time-r_start_time)/1000;
    end
    
    
end

