function [hrv_features_struct] = calc_hrv_features(app,type,window_size)
%CALC_HRV_FEATURES Calculate HRV features 
%   Input
%   app: contain the application public data
%   type: p = participant, c = care-giver
%   window_size: in points (not in ms)
%   
%   Output
%   hrv_features_struct: contain all the feature calculated
%   Features 
%   mean_RR : mean of RR
%   std_RR : std of RR
%   mean_succ_diff : mean successive difference
%   std_succ_diff : std successive difference
%   rms_succ_diff : root mean square of successive difference
%   pRR20 : pRR20 (see paper)
%
%   Paper: Unobtrusive Real-time Heart Rate Variability Analysis for the 
%          Detection of Orthostatic Dysregulation

    %% Creating variables
    hrv_features_struct = struct();
    hrv_features_struct.mean_RR = [];
    hrv_features_struct.std_RR = [];
    hrv_features_struct.mean_succ_diff = [];
    hrv_features_struct.std_succ_diff = [];
    hrv_features_struct.rms_succ_diff = [];
    hrv_features_struct.pRR20 = [];
    
    %% Selecting Data
    if(strcmp(type,"p"))
        hr = app.HR_p{:,2};
    else
        hr = app.HR_c{:,2};
    end
    hr = str2double(hr);
    RR_intervals = (60./hr); % To get RR in seconds
    RR_intervals = RR_intervals.*1000 % To get RR in milliseconds
    
    %% Feature calculation
    % Using a window to calculate feature vector
    for i = 1:window_size:(size(RR_intervals,1)-window_size)
        win_hr = RR_intervals(i:i+window_size,1);
        diff_win_hr = diff(win_hr);
        % Average of RR intervals
        hrv_features_struct.mean_RR = [hrv_features_struct.mean_RR; mean(win_hr)];
        % Standard deviation of RR intervals
        hrv_features_struct.std_RR = [hrv_features_struct.std_RR; std(win_hr)];
        % Average of successive differences
        hrv_features_struct.mean_succ_diff = [hrv_features_struct.mean_succ_diff; mean(diff_win_hr)];
        % Standard deviation of successive differences
        hrv_features_struct.std_succ_diff = [hrv_features_struct.std_succ_diff; std(diff_win_hr)];
        % Root mean square of successive differences
        hrv_features_struct.rms_succ_diff = [hrv_features_struct.rms_succ_diff; rms(diff_win_hr)];
        % Number of successive differences >= 20ms divided by all RR intervals
        threshold_rms = 20; %in ms
        hrv_features_struct.pRR20 = [hrv_features_struct.pRR20; size(diff_win_hr(diff_win_hr > threshold_rms),1)/size(diff_win_hr,1)];
    end

end

