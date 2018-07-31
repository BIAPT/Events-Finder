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

    %% Initiating the sqi data inside the Data structure
    if(strcmp(type,"p"))
        %BVP
        app.Data.p.bvp.filt = bvp_struct.filt;
        app.Data.p.bvp.score = bvp_struct.score;
        app.Data.p.bvp.sqi = bvp_struct.sqi;
        %SC
        app.Data.p.sc.filt = sc_struct.filt;
        app.Data.p.sc.score = sc_struct.score;
        app.Data.p.sc.sqi = sc_struct.sqi;
        %TEMP
        app.Data.p.temp.filt = temp_struct.filt;
        app.Data.p.temp.score = temp_struct.score;
        app.Data.p.temp.sqi = temp_struct.sqi;
    else
        %BVP
        app.Data.c.bvp.filt = bvp_struct.filt;
        app.Data.c.bvp.score = bvp_struct.score;
        app.Data.c.bvp.sqi = bvp_struct.sqi;
        %SC
        app.Data.c.sc.filt = sc_struct.filt;
        app.Data.c.sc.score = sc_struct.score;
        app.Data.c.sc.sqi = sc_struct.sqi;
        %TEMP
        app.Data.c.temp.filt = temp_struct.filt;
        app.Data.c.temp.score = temp_struct.score;
        app.Data.c.temp.sqi = temp_struct.sqi;
    end
end

