clear vars;
close all;

filename = 'x06Simple.csv';
datafile = 'input1.mat';

if(exist(datafile, 'file'))
    load(datafile);
else
    fid = fopen(filename);
    if(fid<0)
        disp('File not found')
        return
    end
    
    data = csvread(filename, 1);
    save(datafile);
end

newData = data;

% Randomize the rows.
s = RandStream('mt19937ar', 'Seed', 0);
newData = newData(randperm(s, size(newData, 1)), :);

newData = newData(:, 2:end);

pick = ceil(size(newData, 1) * 2 / 3);

[stdData, means, stds] = standardize(newData(1:pick,:));

X1 = ones(size(stdData, 1),1);

stdData = [X1, stdData];

trainX = stdData(:, 1:end-1);
trainY = newData(1:pick, end);

theta = inv((trainX.' * trainX)) * trainX.' * trainY;
disp(theta);

pick = pick + 1;

testX = newData(pick:end, 1:end-1);
actualY = newData(pick:end, end);

predictedY = zeros(size(actualY,1), 1);



% Standardize testX
means = means(1, 1:end-1);
stds = stds(1,1:end-1);

meanArray = repmat(means, size(testX,1), 1);
stdArray = repmat(stds, size(testX,1), 1);

testX = testX - meanArray;
testX = testX ./ stdArray;
%



MSE = 0;

for c = 1:size(testX,1)
   predictedY(c) = theta(1,1) + (theta(2,1) * testX(c,1)) + (theta(3,1) * testX(c,2));
   MSE = MSE + (actualY(c) - predictedY(c)) ^ 2;
end

RMSE = sqrt(MSE * (1/length(predictedY)));

disp(RMSE);

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