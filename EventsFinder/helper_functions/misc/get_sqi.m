function [bvp_struct,sc_struct,temp_struct] = get_sqi(app,type)
%GET_SQI This function calls the sqi code that Jason developped and return the sqi for the three variables
%   Input
%   app: contain the application public data
%   type: p = participant, c = care-giver
%   
%   Output

    %% Setting up variables
    bvp_struct = struct();
    sc_struct = struct();
    temp_struct = struct();
    

    %% Selecting data from Participant or Care-giver
    if(strcmp(type,"p"))
        bvp_mat = app.Data.p.bvp.raw;
        temp_mat = app.Data.p.temp.raw;
        eda_mat = app.Data.p.sc.raw;
    else
        bvp_mat = app.Data.c.bvp.raw;
        temp_mat = app.Data.c.temp.raw;
        eda_mat = app.Data.c.sc.raw;
    end
    
    %% Getting the Signal quality index
    [bvp_struct,sc_struct,temp_struct] = comp_SQI_3(bvp_mat,eda_mat,temp_mat);
end

