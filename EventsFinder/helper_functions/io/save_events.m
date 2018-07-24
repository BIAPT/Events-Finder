function save_events(app,events,type)
%SAVE_EVENTS Save the events into the master marker file for the electron app
%   Input
%   app: contain the application public data
%   events: the events that passed the threshold
%   type: p = participant, c = care-giver

    %% Creating the files
    % Master File
    master_file_name = app.MarkerFileNameEditField.Value;
    master_file_name = strcat(master_file_name,'_',num2str(app.time_stamp),".json");
    master_file_name = strcat(app.saving_directory,'/',master_file_name);
    master_fileID = fopen(master_file_name,'a');
    
    % Individual File
    individual_file_name = app.MarkerFileNameEditField.Value;
    individual_file_name = strcat(individual_file_name,'_',type);
    individual_file_name = strcat(individual_file_name,'_',num2str(app.time_stamp),".json");
    individual_file_name = strcat(app.saving_directory,'/',individual_file_name);
    individual_fileID = fopen(individual_file_name,'w');

    %% Setup
    % Setting up participant/care-giver specific variables
    if(strcmp(type,"p"))
        class = "marker-red";
        fprintf(master_fileID,'[\n'); % if its participant write first [
        event_type = app.event_type_p;
    else
        class = "marker-blue";
        event_type = app.event_type_c;
    end
    
    %% Writing
    fprintf(individual_fileID,'[\n');
    % Iterate through the events and write them into the JSON file
    for i = 1:size(events,1)  
        % Codify Eda,temp,hr into numbers from 1 to 3
        if(event_type(i) == 1) %Eda
            mod_type = 1;
        elseif(event_type(i) == 2)%Hr
            mod_type = 2;
        else %Temperature
            mod_type = 3;
        end
        
        if(i ~= size(events,1) || strcmp(type,"p"))
            fprintf(master_fileID,'{"time": %d, "text": "%d", "class": "%s"},\n',events(i),mod_type,class);
            fprintf(individual_fileID,'{"time": %d, "text": "%d", "class": "%s"},\n',events(i),mod_type,class);
        else
            fprintf(master_fileID,'{"time": %d, "text": "%d", "class": "%s"}\n',events(i),mod_type,class);
            fprintf(individual_fileID,'{"time": %d, "text": "%d", "class": "%s"}\n',events(i),mod_type,class);
        end
    end

    if(strcmp(type,"c"))
        fprintf(master_fileID,']\n'); % if care-giver write last ]
    end
    fprintf(individual_fileID,']\n');

    fclose(master_fileID);
    fclose(individual_fileID);
end

