function [averaged_array,time_array,bad_time_array,averaged_sqi] = win_average(app,type,mod,win_size,stop)
%WIN_AVERAGE  % Average the raw data and return an averaged array along with the corresponding time array.
% Also, tag which time is a bad time that should be ignored if there happen to have event.
% To get the bad time this function use the signal quality index calculated elsewhere in the application
%   Input
%   app: contain the application public data
%   type: p = participant, c = care-giver
%   mod: modality (hr,eda,temp)
%   win_size: window size
%   stop: end of the recording in system time
%   Ouput
%   averaged_array: array of window averaged data points
%   time_array: corresponding time array
%   bad_time_array: time point that are deemed bad
%   averaged_sqi: array of sqi values that are averaged to correspond to
%   the averaged_array.

    %% Setting default values
    data = [];
    time = [];
    sqi = [];
    bad_time_array = [];
    averaged_sqi = [];
    sqi_threshold = 0;
    arr_ind = 1;
    bad_arr_ind = 1;


    %% Selecting Data from Participant or Care-giver 
    if(strcmp(type,"p"))
        hr = app.Data.p.hr.raw;
        hr_time = app.Data.p.hr.corr_time;
        temp = app.Data.p.temp.filt;
        temp_time = app.Data.p.temp.corr_time;
        sc = app.Data.p.sc.filt;
        sc_time = app.Data.p.sc.corr_time;        
        sqi_temp = app.Data.p.temp.sqi;
        sqi_sc = app.Data.p.sc.sqi;
    else
        hr = app.Data.c.hr.raw;
        hr_time = app.Data.c.hr.corr_time;        
        temp = app.Data.c.temp.filt;
        temp_time = app.Data.c.temp.corr_time;        
        sc = app.Data.c.sc.filt;
        sc_time = app.Data.c.sc.corr_time;  
        sqi_temp = app.Data.c.temp.sqi;
        sqi_sc = app.Data.c.sc.sqi;
    end

    %% Selecting Data from Right Modality
    if(strcmp(mod,'hr'))
        time = hr_time;
        data = hr;
    elseif(strcmp(mod,'temp'))
        time = temp_time;
        data = temp;
        sqi = sqi_temp;
        sqi_threshold = mean(sqi)-std(sqi);
    elseif(strcmp(mod,'eda'))
        time = sc_time;
        data = sc;
        sqi = sqi_sc;
        sqi_threshold = mean(sqi)-std(sqi); 
    end

    %% Averaging
    % Averaging step:
    % Going from start time to stop time with a given window size
    % we averaged the data points that are within.
    max_index = size(time,1);
    current_index = 1;
    for time_stamp = 0:win_size:(stop-win_size)
        %Reset some variables and get current time
        total_size = 0;
        total_data = 0;
        total_sqi = [];
        isBadTime = 0;
        current_time = time(current_index,1);
        % While we are in that window we sum the data points together
        % if the sqi is too low for one point in this window we flag the whole thing as bad
        while(current_time < (time_stamp+win_size) && (current_index < max_index))
            total_data = total_data + data(current_index,1);
            total_size = total_size + 1;
            if(~strcmp(mod,'hr'))
                total_sqi = [total_sqi, sqi(current_index)];    
            end

            if(~strcmp(mod,'hr') && sqi(current_index) < sqi_threshold)
                isBadTime = 1;
            end
            current_index = current_index + 1;
            current_time = time(current_index,1);
        end

        % If we averaged something within this window we add to the averaged
        % array and we choose the middle point to be the time stamp
        % if this was a bad sqi window we record that time stamp as being unreliable.
        if(total_size > 0)
            averaged_data = total_data/total_size;
            averaged_array(arr_ind,1) = averaged_data;
            time_array(arr_ind,1) = time_stamp+(win_size/2);
            if(~strcmp(mod,'hr'))
                averaged_sqi(arr_ind) = min(total_sqi);
            end
            
            if(isBadTime)
                bad_time_array(bad_arr_ind,1) = time_array(arr_ind,1);
                bad_arr_ind = bad_arr_ind + 1;
            end
            arr_ind = arr_ind + 1;
        end
    end
    
    
    
end