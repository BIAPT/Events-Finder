function update_data_struct(app,update_type)
%UPDATE_DATA_STRUCT Summary of this function goes here
%   Input
%   app: contain the application public data
%   update_type: decide what we should update in the app

    if(strcmp(update_type,"corr_time"))
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

end

