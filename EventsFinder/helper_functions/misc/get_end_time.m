function end_time = get_end_time(app,type)%(hr_table,temp_table,eda_table)
%GET_END_TIME return the ending of the recording
%   Input
%   app: contain the application public data
%   type: p = participant, c = care-giver
%   Output
%   end_time: the ending system time of the recording

    % Get the last time index in the data table for participant and care-giver
    if(strcmp(type,"p"))
        hr_end = str2num(app.HR_p{end,1}{1});
        temp_end = str2num(app.TEMP_p{end,1}{1});
        eda_end = str2num(app.EDA_p{end,1}{1});
    else
        hr_end = str2num(app.HR_c{end,1}{1});
        temp_end = str2num(app.TEMP_c{end,1}{1});
        eda_end = str2num(app.EDA_c{end,1}{1});
    end

    end_time = max([hr_end,temp_end,eda_end]);
end

