function [avg_data] = moving_average(data,win_size)
filteredpoint = 0;

for n = win_size:length(data)
    for j = 0:(win_size - 1)
        filteredpoint = filteredpoint + data(n - j);
    end
    avg_data(n) = filteredpoint / win_size;
    filteredpoint = 0;
end

%figure; subplot(2,1,1); plot(time, file); subplot(2,1,2); plot(time, y, 'r');

%dlmwrite('filteredEDA.txt', y);
