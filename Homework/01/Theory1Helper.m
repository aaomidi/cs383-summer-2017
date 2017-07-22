clear vars;
close all;


data = [-2, 1; -5, -4; -3, 1; 0,3;-8,11;-2,5;1,0;5,-1;-1,-3;6,1];

disp(data);

means = zeros(1,2);
stds = zeros(1,2);

for c = 1:2
    means(c) = mean(data(:,c));
    stds(c) = std(data(:,c));
end

meanArray = repmat(means, size(data,1), 1);
stdArray = repmat(stds, size(data,1), 1);

newData = data;

newData = newData - meanArray;
newData = newData ./ stdArray;

disp(newData);

disp(newData.');

trans = cov(newData);
disp(newData.' * newData * 1/9);

disp(cov(newData));

[eigenVectors,eigenValues] = eig(trans);

disp(eigenValues);
disp(eigenVectors);

subtr = eigenValues(1,1) * eye(2);

disp(subtr);

disp(trans-subtr);

subtr = eigenValues(2,2) * eye(2);
disp(subtr);
disp(trans-subtr);

disp(data * eigenVectors(:,2))