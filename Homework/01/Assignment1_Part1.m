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
means = zeros(1,9);
stds = zeros(1,9);

stds(1) = 1;
for c = 2:9
    means(c) = mean(data(:,c));
    stds(c) = std(data(:,c));
end

meanArray = repmat(means, size(data,1), 1);
stdArray = repmat(stds, size(data,1), 1);



newData = data;

newData = newData - meanArray;
newData = newData ./ stdArray;

%disp(newData(:,2:end))

covMatrix = cov(newData(:,2:end));

disp(covMatrix);

[eigenVectors,eigenValues] = eig(covMatrix);

disp(eigenValues);
disp(eigenVectors);

disp(eigenVectors(:,7:end));

newData = newData(:,2:end) * eigenVectors(:,7:end);

features = data(:,1);

%disp(newData);
figure(1);

% First dimension
d1 = newData(:,1);
% Second dimension
d2 = newData(:,2);

plot(d2(features==1),d1(features==1),'or');
hold on;
plot(d2(features==-1),d1(features==-1),'xb');

hold off;

title('PCA');

legend('+1','-1');



