clear vars;
close all;

data = [-2, 1; -5, -4; -3, 1; 0,3;-8,11;-2,5;1,0;5,-1;-1,-3;6,1];

newData = standardize(data);

newData = [newData(:,1), data(:,2)];

X = newData(:,1);

X1 = ones(size(X,1),1);

X = [X1, X];

Y = newData(:,2);

theta = inv((X.'*X)) * X.'*Y;

disp(theta);

plot(newData(:,1), newData(:,2),'ro');

% Standardizes the data input
function [newData] = standardize(data)
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