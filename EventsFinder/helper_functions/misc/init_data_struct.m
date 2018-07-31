function init_data_struct(app)
%INIT_DATA_STRUCT  will initiate the app.Data structure with default values
%   Input
%   app: contain the application public data
    
    %% Create the basic data structure
    mod_struct = struct();
    mod_struct.raw = [];
    mod_struct.avg = [];
    mod_struct.systime = [];
    mod_struct.corr_time = [];
    mod_struct.avg_corr_time = [];
    mod_struct.filt = [];
    mod_struct.corr_time_filt = [];
    mod_struct.sqi = [];
    mod_struct.avg_sqi = [];
    mod_struct.score = -1;
    mod_struct.bad_time = [];

    %% Create the user structure
    user_struct = struct();
    user_struct.hr = mod_struct;
    user_struct.sc = mod_struct;
    user_struct.temp = mod_struct;
    user_struct.bvp = mod_struct;

    %% Update the Data structure
    app.Data.p = struct();
    app.Data.p = user_struct;
    app.Data.c = struct();
    app.Data.c = user_struct;

end

