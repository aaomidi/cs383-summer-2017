
data = [216,5.68,1;69,4.78,1;302,2.31,0;60,3.16,1;393,4.2,0];

[newData, means, stds] = standardize(data(:,1:end-1));

disp(mean(newData(:,1)));
disp(std(newData(:,1)));

disp((242-208)/145.22);
disp((4.56-4.03)/1.33);

a=1/2.51 * exp(-1/2 * 0.2341^3);
b=1/2.51 * exp(-1/2 * 0.3985^3);

disp ((a*b*3/5)/(2*a*b*2/5))

% Standardizes the data input
function [newData, means, stds] = standardize(data)
    s = size(data,2);
    means = zeros(1,s);
    stds = zeros(1,s);

    for c = 1:s
        means(c) = mean(double(data(:,c)));
        stds(c) = std(double(data(:,c)));
    end
    meanArray = repmat(means, size(data,1), 1);
    stdArray = repmat(stds, size(data,1), 1);
    
    newData = data;
    
    newData = newData - meanArray;
    newData = newData ./ stdArray;
end