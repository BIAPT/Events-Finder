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
        bvp = app.BVP_p;
        temp = app.TEMP_p;
        eda = app.EDA_p;
    else
        bvp = app.BVP_c;
        temp = app.TEMP_c;
        eda = app.EDA_c;
    end

    %% Converting table into a matrix
    bvp_mat = str2double(bvp{1:end,2});
    temp_mat = str2double(temp{1:end,2});
    eda_mat = str2double(eda{1:end,2});
    
    
    %% Getting the Signal quality index
    [bvp_struct,sc_struct,temp_struct] = comp_SQI_3(bvp_mat,eda_mat,temp_mat);
end

