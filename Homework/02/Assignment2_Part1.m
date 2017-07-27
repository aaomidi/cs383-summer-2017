clear vars;
close all;



filename = 'diabetes.csv';
datafile = 'input1.mat';

if(exist(datafile, 'file'))
    load(datafile);
else
    fid = fopen(filename);
    if(fid<0)
        disp('File not found')
        return
    end
    
    data = csvread(filename);
    save(datafile);
end


std = standardize(data(:,2:end));
newData = [data(:,1), std];

%otherData = kmeme(newData,2,7,6);

otherData = kmeme(newData(:,8:-1:7), 2, 1, 2);
%otherData = kmeme(newData, 5, 2, 3);

function [X] = kmeme(X, k, xcol, ycol)
    s = RandStream('mt19937ar','Seed',0);
    
    X = X(randperm(s, size(X,1)), :);
    oldX = X;
    
    %X = X(:, 2:end);
    kVals = X(1:k, :);
    
    
    d1 = X(:, xcol);
    d2 = X(:, ycol);
 
    %plot(d1, d2, 'rx');
    %hold on;
    %plot(kVals(:,xcol),kVals(:,ycol), 'bo');
    
    
    maxY = size(X,2);
    
    X = [X, zeros(size(X,1),1)];
   
    % loop until we hit episilon
    for j = 1:9999
        % loop over entire data
        for c = 1:size(X,1)
            working = X(c, 1:end-1);
            % loop over all kVals
            distances = zeros(1, size(kVals,1));
            for i = 1:size(kVals,1)
                kVal = kVals(i,:);
                distances(i) =  pdist2(kVal, working, 'euclidean');
            end
            [M, I] = min(distances);
            X(c, end) = I;
        end
        oKV = kVals;
        last = size(X,2);
        for i = 1:size(kVals,1)
            allData = (X(X(:,last)==i,1:end-1));
            kVals(i,:) = mean(allData);
        end
        
        diff = pdist2(kVals, oKV, 'cityblock');
        if diff(1) < eps
            disp(j);
            break
        end
    end
    myPlot(X, kVals, k, xcol, ycol); 
end

function [] = myPlot(X, kMeans, k, xcol, ycol)    
    colors = ['g';'r';'c';'r';'g';'b';'k'];
    for c = 1:k
        dx = X(X(:,end)==c, xcol);
        dy = X(X(:,end)==c, ycol);
        disp(size(dx));
        plot(dx, dy, strcat(colors(c),'x'));
        hold on;
        plot(kMeans(c,xcol), kMeans(c,ycol), strcat(colors(c),'o'), 'MarkerSize',10,'MarkerEdgeColor','k', 'MarkerFaceColor', colors(c));
        hold on;
    end
end


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