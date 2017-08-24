clear vars;
close all;
filename = 'CTG.csv';
datafile = 'input2.mat';

if(exist(datafile,'file'))
    load(datafile)
else
    fid = fopen(filename);
    if(fid<0)
        disp('File not found')
        return
    end
    
    data = csvread(filename,2);

    %save(datafile)
end

temp = data(:, 1:end-2);
data = [temp, data(:, end)];

s = RandStream('mt19937ar', 'Seed', 0);
randomData = data(randperm(s, size(data, 1)), :);

i = size(data,1);
i = ceil(i*2/3);

trainData = randomData(1:i,:);
testData = randomData(i+1:end,:);

[stdData, means, stds] = standardize(trainData(:, 1:end-1));

stdData = [stdData, trainData(:,end)];
meanArray = repmat(means, size(testData, 1), 1);
stdArray = repmat(stds, size(testData, 1), 1);
oldTestData = testData;


testData = testData(:, 1:end-1);

testData = testData - meanArray;
testData = testData ./ stdArray;

testData = [testData, oldTestData(:, end)];

models = [];

[selector1, data1, label1] = onOneOne(stdData, 1);
[selector2, data2, label2] = onOneOne(stdData, 2);
[selector3, data3, label3] = onOneOne(stdData, 3);

model1 = fitcsvm(vertcat(data1, data2), vertcat(label1, label2));
model2 = fitcsvm(vertcat(data1, data3), vertcat(label1, label3));
model3 = fitcsvm(vertcat(data2, data3), vertcat(label2, label3));

results1 = predict(model1, testData(:, 1:end-1));
results2 = predict(model2, testData(:, 1:end-1));
results3 = predict(model3, testData(:, 1:end-1));

finalResults = [results1, results2, results3, testData(:, end)];


correct = 0;
for i=1:length(finalResults)
    row = finalResults(i,:);
    prediction = mode(row(:, 1:end-1));
    
    if(prediction == row(:,end))
        correct = correct + 1;
    end
end

accuracy = correct / length(finalResults);
fprintf('Accuracy: %0.2f%% \n', accuracy*100);


function [selector, data, label] = onOneOne(X, val)
    selector = X(:,end) == val;
    data = X(selector, 1:end-1);
    label = X(selector, end);
    
end

function [B] = insertData(A, row, k)
    B = A;
    for i=1:k
       x = A(i,:);
       oldVal = x(1,1);
       newVal = row(1,1);
       
       if(oldVal < newVal)
           continue
       end
      
      head = A(1:i-1,:);
      tail = A(i:k, :);
      B = vertcat(head, row, tail);
      B = B(1:k, :);
      return
    end
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