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
    [hr_struct.avg,hr_struct.time,bad_hr_struct.time,~] = win_average(app,type,'hr',win_size,app.start_time,end_time);
    [temp_struct.avg,temp_struct.time,bad_temp_struct.time,temp_struct.avg_sqi] = win_average(app,type,'temp',win_size,app.start_time,end_time);
    [sc_struct.avg,sc_struct.time,bad_sc_time,sc_struct.avg_sqi] = win_average(app,type,'eda',win_size,app.start_time,end_time);

    %% Filtering the Signals
    %(EDA) Apply oneEuro filter
        %Declare oneEuro object
        a = oneEuro;
        %Alter filter parameters to tune
        a.mincutoff = 100.0;
        a.beta = 4.0;
    noisySignal = sc_struct.avg;
    filteredSignal = zeros(size(noisySignal));
    for i = 1:length(noisySignal)
        filteredSignal(i) = a.filter(noisySignal(i),i);
    end
    sc_struct.avg = filteredSignal;
    %sc_struct.avg = moving_average(sc_struct.avg,15)';
    %(HR) Apply Cubic Smoothing Spline function
    p = 0.001;
    hr_struct.time_clean = (hr_struct.time-app.start_time)/1000;
    hr_struct.avg = csaps(hr_struct.time_clean,hr_struct.avg,p,hr_struct.time_clean); 
    %(TEMP) Apply Exponential Decay filter
    temp_struct.avg = exp_decay(temp_struct.avg,0.80);

    %% Find Bad Time Points
    % Concatenate the bad times for TEMP and EDA and take only the non redondant ones
    bad_time = unique([bad_temp_struct.time;bad_sc_time]);

    %% (HR) Events Detection
     if(app.HRCheckBox.Value == 1)
        % An event is tagged if there is a prominent peak (default 10 bpm)
        [hr_peak_val,hr_peak_idx,~,hr_peak_prom] = findpeaks(hr_struct.avg,'MinPeakProminence',curr_thresh.hr); 
        hr_peak_time = hr_struct.time(hr_peak_idx);
        %Find Valleys
        hr_inverted = -hr_struct.avg;
        [hr_valley_val,hr_valley_idx,~,hr_valley_prom] = findpeaks(hr_inverted,'MinPeakProminence',curr_thresh.hr);
        hr_valley_time = hr_struct.time(hr_valley_idx);
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
        events.hr.time = (events.hr.time-app.start_time)/1000;
     end
    
    %% (SC) Events Detection
    if(app.EDACheckBox.Value == 1)
       % An event is tagged if there is a given change in a 10 second interval (default about 0.1 microsemens)
       offset = 10/0.5;
       for i = 1:(size(sc_struct.time,1)-offset)
           eda_change = abs(sc_struct.avg(i+offset,1) - sc_struct.avg(i,1)) ;
           if(eda_change > curr_thresh.eda && ~ismember(sc_struct.time(i,1),bad_time))
               events.eda.time = [events.eda.time; (sc_struct.time(floor(i+offset/2),1)-app.start_time)/1000];
               events.eda.diff = [events.eda.diff; eda_change/curr_thresh.eda];
           end
       end
    end   
    
    %% (TEMP) Events Detection
    if(app.TempCheckBox.Value == 1)
        % An event is tagged if there is a prominent peak (default 0.1 degree)
        [temp_peak_val,temp_peak_idx,~,temp_peak_prom] = findpeaks(temp_struct.avg,'MinPeakProminence',curr_thresh.temp); 
        temp_peak_time = temp_struct.time(temp_peak_idx);
        %Find Valleys
        temp_inverted = -temp_struct.avg;
        [temp_valley_val,temp_valley_idx,~,temp_valley_prom] = findpeaks(temp_inverted,'MinPeakProminence',curr_thresh.temp);
        temp_valley_time = temp_struct.time(temp_valley_idx);
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
        events.temp.time = (events.temp.time-app.start_time)/1000;
    end
    
    %% Log the All Events
    log_events(app,events,type);
    
    %% Events Filtering
    % Here we select only the most salient events
    % The number of markers are given by app.NumberofMarkersEditField.Value
    
    % Setting up variables
    % Window size to allow for two consecutive events
    EDA_win = 10;
    TEMP_win = 25;
    HR_win = 10;
    % Current index
    i = 1;
    while(i <= app.number_markers)
        % Get the maximum difference to the threshold for each modality
        [max_eda,ind_eda] = max(events.eda.diff);
        [max_hr,ind_hr] = max(events.hr.diff);
        [max_temp,ind_temp] = max(events.temp.diff);

        %Adjust weight of data type with scaling factor
        max_eda= max_eda*curr_thresh.eda_sf;
        max_hr= max_hr*curr_thresh.hr_sf;
        max_temp= max_temp*curr_thresh.temp_sf;

        % If one of the data type was empty replace with a -1
        if(isempty(max_eda))
            max_eda = -1;
        end
        if(isempty(max_hr))
            max_hr = -1;
        end
        if(isempty(max_temp))
            max_temp = -1;
        end
        
        % If all of them are empty we just break out
        if(max_temp <= -1 && max_hr <= -1 && max_eda <= -1)
            display('No more significant events')
            break;
        end

        % Here we check which one has the greatest difference and select
        % its time as well as its data type as marker. If there is already an event
        % for that time period we simply ignore it.
        isAdded = 0;
%TODO: Refactor the part within the if statements
        if((max_eda >= max_hr) && (max_eda >= max_temp) && max_eda ~= -1)
            % Setting the boundaries
            curr_eda_time = events.eda.time(ind_eda,1);
            lower_bound = curr_eda_time - EDA_win;
            upper_bound = curr_eda_time + EDA_win;
            % Check if there is already an event there
            if(~isempty(event_struct.events(event_struct.events > lower_bound & event_struct.events < upper_bound)))
                %If yes do nothing
                isAdded = 0;
            else
                % Otherwise Add Event
                event_struct.events = [event_struct.events ; int32(events.eda.time(ind_eda,1))];
                event_struct.type = [event_struct.type; 1];
                isAdded = 1;
            end
            events.eda.diff(ind_eda,1) = -1;
        elseif((max_hr >= max_eda) && (max_hr >= max_temp) && max_hr ~= -1)
            % Setting the boundaries
            curr_hr_time = events.hr.time(ind_hr,1);
            lower_bound = curr_hr_time - HR_win;
            upper_bound = curr_hr_time + HR_win; 
            % Check if there is already an event there
            if(~isempty(event_struct.events(event_struct.events > lower_bound & event_struct.events < upper_bound)))
                %If yes do nothing
                isAdded = 0;
            else
                % Otherwise Add Event
                event_struct.events = [event_struct.events ; int32(events.hr.time(ind_hr,1))];
                event_struct.type = [event_struct.type; 2];
                isAdded = 1;
            end
            events.hr.diff(ind_hr,1) = -1;
        elseif((max_temp >= max_eda) && (max_temp >= max_hr) && max_temp ~= -1)
            % Setting the boundaries
            curr_temp_time = events.temp.time(ind_temp,1);
            lower_bound = curr_temp_time - TEMP_win;
            upper_bound = curr_temp_time + TEMP_win;   
            % Check if there is already an event there
            if(~isempty(event_struct.events(event_struct.events > lower_bound & event_struct.events < upper_bound)))
                % If yes do nothing
                isAdded = 0;
            else
                % Otherwise Add Event
                event_struct.events = [event_struct.events ; int32(events.temp.time(ind_temp,1))];
                event_struct.type = [event_struct.type; 3];
                isAdded = 1;
            end
            events.temp.diff(ind_temp,1) = -1;
        end

        % Increment the counter only if there was something added
        if(isAdded == 1)
            i = i + 1;
        end       
    end
    
    %% Sort Events
    % Here we sort the data in increasing order of time
    % We save the types and we return the events
    % Create our sort matrix
    sort_matrix = [event_struct.events,event_struct.type];
    sorted_type = sortrows(sort_matrix,1);
    % Update the data in the structure
    event_struct.events = sort(event_struct.events);
    event_struct.type = sorted_type(:,2);
end

