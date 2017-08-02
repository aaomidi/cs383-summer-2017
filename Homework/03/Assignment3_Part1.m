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

stdData = standardize(data);

newData = [stdData(:, 1:end-1), data(:,end)];

X1 = ones(size(newData,1),1);

newData = [X1, newData];

X = newData(:,1:end-1);
Y = newData(:, end);

theta = inv((X.'*X)) * X.'*Y;
disp(theta);


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