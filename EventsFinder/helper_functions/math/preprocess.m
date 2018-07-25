function [data_struct] = preprocess(app)
%PREPROCESS Preprocess the raw data to clean it
%   Input
%   app:
%   
%   Output
%   data_struct: structure containing the cleaned data
%   for every modality and both the participant and the care-giver
%   For each modality we have the filtered signal with a corresponding
%   signal quality array
    %%  Creating variables
    data_struct = struct();
    % Participant
    % Blood Volume Pulse
    data_struct.p.bvp.time = [];
    data_struct.p.bvp.filt = [];
    data_struct.p.bvp.sq = [];
    % Heart Rate 
    data_struct.p.hr.time = [];
    data_struct.p.hr.filt = [];
    data_struct.p.hr.sq = [];
    % Skin Conductance
    data_struct.p.sc.time = [];
    data_struct.p.sc.filt = [];
    data_struct.p.sc.sq = [];
    % Temperature
    data_struct.p.temp.time = [];
    data_struct.p.temp.filt = [];
    data_struct.p.temp.sq = [];
    
    % Care-giver
    % Blood Volume Pulse
    data_struct.c.bvp.time = [];
    data_struct.c.bvp.filt = [];
    data_struct.c.bvp.sq = [];
    % Heart Rate
    data_struct.c.hr.time = [];
    data_struct.c.hr.filt = [];
    data_struct.c.hr.sq = [];
    % Skin Conductance
    data_struct.c.sc.time = [];
    data_struct.c.sc.filt = [];
    data_struct.c.sc.sq = [];
    % Temperature
    data_struct.c.temp.time = [];
    data_struct.c.temp.filt = [];
    data_struct.c.temp.sq = [];
    
   %% Thresholding (TODO Wait for threshold from florian)
   
   %% Filtering (TODO use the exponential filter)
   
   
end

