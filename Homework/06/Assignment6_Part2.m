clear vars;
close all;
filename = 'spambase.data';
datafile = 'input2.mat';

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


meanArray = repmat(means, size(testData, 1), 1);
stdArray = repmat(stds, size(testData, 1), 1);
oldTestData = testData;


testData = testData(:, 1:end-1);

testData = testData - meanArray;
testData = testData ./ stdArray;

testData = [testData, oldTestData(:, end)];


LEARN = 0.5;
D = size(stdData,2);
N = length(stdData);
M = 20;

labels = unique(stdData(:, end));
K = length(labels) - 1;


Y = stdData(:, end);
% Add bias features.
stdData = [stdData, ones(N,1)];
X = stdData(:, 1:end-1);

testY = testData(:,end);
testData = [testData, ones(length(testData), 1)];
testX = testData(:,1:end-1);

    
BETA = rand(D, M);
THETA = rand(M, K);

for i = 1:1000

    
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
    

end

RESULTS = zeros(11, 2);

for i = 1:11
    TP = 0;
    FP = 0;
    TN = 0;
    FN = 0;
    limit = (i-1)/10;
    for j = 1:length(TestO)
        row = TestO(j, 1);
        if(row > limit)
            if(testY(j,1) == 1)
                TP = TP + 1;
            else
                FP = FP + 1;
            end
        else 
            if(testY(j,1) == 0)
                TN = TN+ 1;
            else
                FN = FN + 1;
            end
        end
    end
    
    precision = TP/(TP+FP);
    recall = TP/(TP+FN);
    
    if(isnan(precision))
        precision = 1;
    end
    
    RESULTS(i, 1) = precision;
    RESULTS(i, 2) = recall;
end
plot(RESULTS(:,1), RESULTS(:,2), '-ko');

ylabel('Recall');
xlabel('Precision');

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