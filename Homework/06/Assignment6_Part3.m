clear vars;
close all;
filename = 'CTG.csv';
datafile = 'input3.mat';

if(exist(datafile,'file'))
    load(datafile)
else
    fid = fopen(filename);
    if(fid<0)
        disp('File not found')
        return
    end
    
    data = csvread(filename,2);

    save(datafile)
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

LEARN = 0.5;
ITERATIONS  = 1000;
D = size(stdData,2);
N = length(stdData);
M = 20;

labels = unique(stdData(:, end));
K = length(labels);


Y = stdData(:, end);
% Add bias features.
stdData = [stdData, ones(N,1)];
X = stdData(:, 1:end-1);

testY = testData(:,end);
testData = [testData, ones(length(testData), 1)];
testX = testData(:,1:end-1);

    
BETA = rand(D, M);
THETA = rand(M, K);

% Encode Y Values

tempY = Y;
Y = zeros(N, 3);
for i = 1:N
    Y(i,:) = encode(tempY(i, 1),3);
end

tempY = testY;
testY = zeros(length(tempY), 3);
for i = 1:length(tempY)
    testY(i,:) = encode(tempY(i, 1),3);
end

% End decode.

RESULTS = zeros(ITERATIONS, 1);
for i = 1:ITERATIONS
    
    H = X * BETA;
    H = 1 ./ (1 + exp(-1 .* H));
    
    O = H * THETA;
    O = 1 ./ (1 + exp(-1 .* O));
    
    EOUT = Y - O;
    THETA = THETA + (LEARN/N) * H.' * EOUT;
    
    EHIDDEN = EOUT * THETA.' .* H .* (1 - H);
    
    BETA = BETA + (LEARN/N) .* X.' * EHIDDEN;
    
    % Evaluate our stuff

    TestH = testX * BETA;
    TestH = 1 ./ (1 + exp(-1 .* TestH));
        
    TestO = TestH * THETA;
    TestO = 1 ./ (1 + exp(-1 .* TestO));
    
    correct = 0;
    for j = 1:length(TestO)
        [val1, idx1] = max(TestO(j,:));
        [val2, idx2] = max(testY(j,:)); 
        
        if (idx1 == idx2)
            correct = correct + 1;
        end
    end
    
    RESULTS(i,1) = (correct/length(testY));
end
plot(RESULTS, '-k');

ylabel('Training Accuracy');
xlabel('Iteration');

function [encoded] = encode(data, len)
    encoded = zeros(1, len);
    encoded(1, data) = 1;
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