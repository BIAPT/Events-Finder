function[y] = movingaverage_test(file,windowsize)
filteredpoint = 0;

for n = windowsize:length(file)
    for j = 0:(windowsize - 1)
        filteredpoint = filteredpoint + file(n - j);
    end
    y(n) = filteredpoint / windowsize;
    filteredpoint = 0;
end

%figure; subplot(2,1,1); plot(time, file); subplot(2,1,2); plot(time, y, 'r');

%dlmwrite('filteredEDA.txt', y);
