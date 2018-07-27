function load_data_struct(app)
%LOAD_DATA_STRUCT Will process the raw data to put them in Data in the right format
%   Input
%   app: contain the application public data

    %% Process Tables into Raw (first column = systime, second = raw)
    % BVP 
    app.Data.p.bvp.systime = str2double(app.BVP_p{:,1}); 
    app.Data.c.bvp.systime = str2double(app.BVP_c{:,1});
    app.Data.p.bvp.raw = str2double(app.BVP_p{:,2});
    app.Data.c.bvp.raw = str2double(app.BVP_c{:,2});
    % HR
    app.Data.p.hr.systime = str2double(app.HR_p{:,1}); 
    app.Data.c.hr.systime = str2double(app.HR_c{:,1});
    app.Data.p.hr.raw = str2double(app.HR_p{:,2});
    app.Data.c.hr.raw = str2double(app.HR_c{:,2});    
    % SC
    app.Data.p.sc.systime = str2double(app.EDA_p{:,1}); 
    app.Data.c.sc.systime = str2double(app.EDA_c{:,1});
    app.Data.p.sc.raw = str2double(app.EDA_p{:,2});
    app.Data.c.sc.raw = str2double(app.EDA_c{:,2});    
    % TEMP
    app.Data.p.temp.systime = str2double(app.TEMP_p{:,1}); 
    app.Data.c.temp.systime = str2double(app.TEMP_c{:,1});
    app.Data.p.temp.raw = str2double(app.TEMP_p{:,2});
    app.Data.c.temp.raw = str2double(app.TEMP_c{:,2});
    
    %% Calculate the correct time in seconds
    % BVP
    app.Data.p.bvp.corr_time = (app.Data.p.bvp.systime - app.start_time)/1000;
    app.Data.c.bvp.corr_time = (app.Data.c.bvp.systime - app.start_time)/1000;
    % HR
    app.Data.p.hr.corr_time = (app.Data.p.hr.systime - app.start_time)/1000;
    app.Data.c.hr.corr_time = (app.Data.c.hr.systime - app.start_time)/1000;
    % SC
    app.Data.p.sc.corr_time = (app.Data.p.sc.systime - app.start_time)/1000;
    app.Data.c.sc.corr_time = (app.Data.c.sc.systime - app.start_time)/1000;    
    % TEMP
    app.Data.p.temp.corr_time = (app.Data.p.temp.systime - app.start_time)/1000;
    app.Data.c.temp.corr_time = (app.Data.c.temp.systime - app.start_time)/1000;
    
end

