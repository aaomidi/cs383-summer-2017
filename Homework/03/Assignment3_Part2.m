clear vars;
close all;

filename = 'x06Simple.csv';
datafile = 'input2.mat';

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

% Ignore first row
newData = newData(:, 2:end);

offset = ones(length(newData), 1);
newData = [offset, newData];

disp(sFolds(newData, 5));

function [RMSE] = sFolds(data, S)
    RMSE = 0
    lenX = length(data);
    
    pick = ceil(length(data) / S);
    
   
    for i = 1:S        
        endX = i * pick;
        if (endX > lenX)
            endX = lenX;
        end
        startX = endX - pick + 1;
        
        
        currentFold = data(1:startX-1,:);
        currentFold = [currentFold; data(endX+1:end,:)];
       
        otherFolds = data(startX:endX, :);   
        
        % remove the offset data
        otherFolds = otherFolds(:, 2:end);
               
        [stdData, means, stds] = standardize(currentFold(:, 2:end-1));
        
        % prepare standardization of testing data
        meanArray = repmat(means, size(otherFolds,1), 1);
        stdArray = repmat(stds, size(otherFolds,1), 1);
       
        stdData = [currentFold(:, 1), stdData];
        stdData = [stdData, currentFold(:, end)];
        
        otherFoldsStd = otherFolds(:, 1:end-1);
        
        % standardize testing data
        otherFoldsStd = otherFoldsStd - meanArray;
        otherFoldsStd = otherFoldsStd ./ stdArray;
        
        otherFolds = [otherFoldsStd, otherFolds(:, end)];
        
        X = stdData(:, 1:end-1);
        Y = stdData(:, end);
        theta = inv((X.' * X)) * X.' * Y;

        
        MSE = 0;
        for j = 1:length(otherFolds)
            predictedY = theta(1,1) + (theta(2,1) * otherFolds(j,1)) + (theta(3,1) * otherFolds(j,2));
            MSE = MSE + ((otherFolds(j,3) - predictedY) ^ 2);
        end
        
        RMSE = RMSE + (MSE / length(otherFolds));
    end
    
    RMSE = sqrt(RMSE / S);
      
end

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