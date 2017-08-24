clear vars;
close all;
filename = 'spambase.data';
datafile = 'input1.mat';

if(exist(datafile,'file'))
    load(datafile)
else
    fid = fopen(filename);
    if(fid<0)
        disp('File not found')
        return
    end
    
    data = csvread(filename);

    save(datafile)
end

%data = data(1:1000, :);

s = RandStream('mt19937ar', 'Seed', 0);
randomData = data(randperm(s, size(data, 1)), :);

i = size(data,1);
i = ceil(i*2/3);

trainData = randomData(1:i,:);
testData = randomData(i+1:end,:);

[stdData, means, stds] = standardize(trainData(:, 1:end-1));

stdData = [stdData, trainData(:,end)];

results = zeros(length(testData), 2);

meanArray = repmat(means, size(testData, 1), 1);
stdArray = repmat(stds, size(testData, 1), 1);
oldTestData = testData;


testData = testData(:, 1:end-1);

testData = testData - meanArray;
testData = testData ./ stdArray;

testData = [testData, oldTestData(:, end)];


model = fitcsvm(stdData(:, 1:end-1), stdData(:, end));
predictedValues = predict(model, testData(:, 1:end-1));

results(:,1) = predictedValues(:, 1);
results(:,2) = testData(:, end);


TP = 0;
FP = 0;
TN = 0;
FN = 0;

for i = 1:length(results)
    X = results(i,:);

    % Predicted
    if X(1,1) == 1
        % Actual
        if X(1,2) == 1
            TP = TP + 1; 
        else
            FP = FP + 1;
        end
    else
        if X(1,2) == 1
            FN = FN + 1;
        else
            TN = TN + 1;
        end
    end
   
end

%disp(TP);
%disp(FP);
%disp(TN);
%disp(FN);

precision = TP/(TP+FP);
recall = TP/(TP+FN);
accuracy = (TP+TN)/(TP+TN+FP+FN);
fMeasure = (2*precision*recall)/(precision+recall);


fprintf("Precision: %0.2f%% \n", precision*100);
fprintf("Recall: %0.2f%% \n", recall*100);
fprintf('F-Measure: %0.2f%% \n', fMeasure*100);
fprintf('Accuracy: %0.2f%% \n', accuracy*100);


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