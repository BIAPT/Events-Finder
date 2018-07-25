function log_events(app,events,type)
%LOG_EVENTS Create a log file containing all the events find with the
%thresholds
%   Input
%   app: contain the application public data
%   events: structure containing all the events and their information

    %% Create File
    filename = strcat(app.MarkerFileNameEditField.Value,'_',type,'_',num2str(app.time_stamp),'.log');
    filename = strcat(app.saving_directory,'/',filename);     
    fileID = fopen(filename,'w');
    
    %% Writing File
    fprintf(fileID,'Date : %s\n',date);
    fprintf(fileID,'Type : %s\n',type);
    fprintf(fileID,'EDA EVENTS: %d | HR EVENTS: %d | TEMP EVENTS: %d\n',size(events.eda.time,1),size(events.hr.time,1),size(events.temp.time,1));
    fprintf(fileID,'mod,time,diff\n');
    for i = 1:size(events.eda.time,1)
        mod = 1;
        fprintf(fileID,'%d, %d ,%d \n',mod,int32(events.eda.time(i,1)),events.eda.diff(i,1));
    end
    for i = 1:size(events.hr.time,1)
        mod = 2;
        fprintf(fileID,'%d, %d, %d \n',mod,int32(events.hr.time(i,1)),events.hr.diff(i,1));
    end
    for i = 1:size(events.temp.time,1)
        mod = 3;
        fprintf(fileID,'%d, %d, %d \n',mod,int32(events.temp.time(i,1)),events.temp.diff(i,1));
    end
    fclose(fileID);
end

