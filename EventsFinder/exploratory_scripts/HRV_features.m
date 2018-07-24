%% Script Info
% Author: Yacine Mahdid
% Contact: Yacine.mahdid@mail.mcgill.ca

HR = HR_p;
window_size = 10; %IN POINTS NOT IN MS
%% Heart Rate to RR intervals conversion
hr = str2double(HR_p.HRData)
RR_intervals = (60./hr); % To get RR in seconds
RR_intervals = RR_intervals.*1000 % To get RR in milliseconds

% For everything else below we will use a sliding window to calculate the
% features.
% List of features calculated:
mean_RR = [];
std_RR = [];
mean_succ_diff = [];
std_succ_diff = [];
rms_succ_diff = [];
pRR20 = [];
aggregate_hr = [];

for i = 1:window_size:(size(RR_intervals,1)-window_size)
    win_hr = RR_intervals(i:i+window_size,1);
    aggregate_hr = [aggregate_hr; win_hr];
    diff_win_hr = diff(win_hr);
%% Average of RR intervals
    mean_RR = [mean_RR; mean(win_hr)];
%% Standard deviation of RR intervals
    std_RR = [std_RR; std(win_hr)];
%% Average of successive differences
    mean_succ_diff = [mean_succ_diff; mean(diff_win_hr)];
%% Standard deviation of successive differences
    std_succ_diff = [std_succ_diff; std(diff_win_hr)];
%% Root mean square of successive differences
    rms_succ_diff = [rms_succ_diff; rms(diff_win_hr)];
%% Number of successive differences >= 20ms divided by all RR intervals
    threshold_rms = 20; %in ms
    pRR20 = [pRR20; size(diff_win_hr(diff_win_hr > threshold_rms),1)/size(diff_win_hr,1)];
end