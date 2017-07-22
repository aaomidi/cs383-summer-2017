clear vars;
close all;

c1 = [-2, 1; -5, -4; -3, 1; 0,3;-8,11];
c2 = [-2,5;1,0;5,-1;-1,-3;6,1];
attached = vertcat(c1,c2);

means = zeros(1,2);
means1 = zeros(1,2);
means2 = zeros(1,2);

stds = zeros(1,2);
stds1 = zeros(1,2);
stds2 = zeros(1,2);

for c = 1:2
    means(c) = mean(double(attached(:,c)));
    
    stds(c) = std(double(attached(:,c)));
end



x1 = c1;
x2 = c2;

meanArray1 = repmat(means, size(c1,1), 1);
stdArray1 = repmat(stds, size(c1,1), 1);

meanArray2 = repmat(means, size(c2,1), 1);
stdArray2 = repmat(stds, size(c2,1), 1);

meanArray = repmat(means, size(attached,1),1);
stdArray = repmat(stds,size(attached,1),1);

x1 = x1 - double(meanArray1);
x1 = x1 ./ stdArray1;

x2 = x2 - double(meanArray2);
x2 = x2 ./ stdArray2;

att = attached;

att = att - double(meanArray);
att = att ./ stdArray;

disp(attached);
disp(att);


xmeans1 = zeros(1,2);
xmeans2 = zeros(1,2);

for c = 1:2
    xmeans1(c) = mean(double(x1(:,c)));
    xmeans2(c) = mean(double(x2(:,c)));
end

disp(xmeans1 - xmeans2);

SB = (xmeans1 - xmeans2).' * (xmeans1 - xmeans2);
disp(SB);

disp(x2);
disp(xmeans2);

y1 = x1;
y2 = x2;

for c = 1:2
    means1(c) = mean(double(x1(:,c)));
    means2(c) = mean(double(x2(:,c)));
    
    stds1(c) = std(double(x1(:,c)));
    stds2(c) = std(double(x2(:,c)));
end

meanArray1 = repmat(means1, size(c1,1), 1);
stdArray1 = repmat(stds1, size(c1,1), 1);

meanArray2 = repmat(means2, size(c2,1), 1);
stdArray2 = repmat(stds2, size(c2,1), 1);

y1 = y1 - double(meanArray1);
y1 = y1 ./ stdArray1;

y2 = y2 - double(meanArray2);
y2 = y2 ./ stdArray2;


s1 =4 * cov(x1);
s2 =4* cov(x2);

S = s1 + s2;

SI = inv(S);

[eigenVectors,eigenValues] = eig(S\SB);

disp(eigenValues);
disp(eigenVectors);

final = att*eigenVectors(:,1);

disp(final);

d1 = x1*eigenVectors(:,1);
d2 = x2*eigenVectors(:,1);

disp(d1);
plot(d1,0,'or');
hold on;
plot(d2,0,'xb');
