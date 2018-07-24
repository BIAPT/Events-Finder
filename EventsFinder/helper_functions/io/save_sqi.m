function [outputArg1,outputArg2] = save_sqi(app,type,bvp_score,sc_score,temp_score)
%SAVE_SQI Save the events into the master marker file for the electron app
%   Input
%   app: contain the application public data
%   type: p = participant, c = care-giver
%   bvp_score,sc_score,temp_score: overall sqi score obtained with
%   SQI_COMP_3

    %% Creating the time-tagged file
    file_name = app.MarkerFileNameEditField.Value;
    file_name = strcat(file_name,'_',num2str(app.time_stamp),'.sqi');
    file_name = strcat(app.saving_directory,'/',file_name);
    
    %% Apending to the file
    fileID = fopen(file_name,'a');
    fprintf(fileID,'type: %s \nbvp score: %d , eda score: %d and temp score: %d\n',type,bvp_score,sc_score,temp_score);
    fclose(fileID);
end

