function end_time = get_end_time(app,type)%(hr_table,temp_table,eda_table)
%GET_END_TIME return the ending of the recording
%   Input
%   app: contain the application public data
%   type: p = participant, c = care-giver
%   Output
%   end_time: the ending system time of the recording

    % Get the last time index in the data table for participant and care-giver
    if(strcmp(type,"p"))
        hr_end = app.Data.p.hr.corr_time(end,1);
        temp_end = app.Data.p.temp.corr_time(end,1);
        sc_end = app.Data.p.sc.corr_time(end,1);
    else
        hr_end = app.Data.c.hr.corr_time(end,1);
        temp_end = app.Data.c.temp.corr_time(end,1);
        sc_end = app.Data.c.sc.corr_time(end,1);
    end

    end_time = max([hr_end,temp_end,sc_end]);
end

