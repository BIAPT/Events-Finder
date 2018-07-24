function [data_struct] = preprocess(app)
%PREPROCESS Preprocess the raw data to clean it
%   Input
%   app:
%   
%   Output
%   data_struct: structure containing the cleaned data
%   for every modality and both the participant and the care-giver

    %%  Creating variables
    data_struct = struct();
    data_struct.p.signal_quality = [];
    data_struct.p.bvp_filt = [];
    data_struct.p.hr_filt = [];
    data_struct.p.sc_filt = [];
    data_struct.p.temp_filt = [];

    data_struct.c.signal_quality = [];
    data_struct.c.bvp_filt = [];
    data_struct.c.hr_filt = [];
    data_struct.c.sc_filt = [];
    data_struct.c.temp_filt = [];
    
   
end

