function[y] = expdecay(file,alpha)
%Exponential decay smoothing filter
%increase alpha for more filtering: uses more past data to compute an
%average
y = file;
for i = 1:(length(file)-1)
    file(i+1)=(file(i)*alpha) + (file(i+1)*(1-alpha));
    y(i,1)=file(i+1);
end 