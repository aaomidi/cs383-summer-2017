clear vars;
close all;

folderName = "yalefaces";
datafile = 'input2.mat';

data = [];
if(exist(datafile, 'file'))
    load(datafile);
else
    files = dir('yalefaces');
    len = size(files);
    
    for i = 1:len(1)
        if(strcmp(files(i).name,'.') || strcmp(files(i).name,'..')|| strcmp(files(i).name,'Readme.txt'))
            continue;
        end
      
        
        file = imread(strcat(files(i).folder,'/',files(i).name));
        subsampled = imresize(file,[40,40]);
        
        flattened = reshape(subsampled, [1,1600]);
        data = vertcat(data,flattened);

    end
    
    save(datafile);
end


means = zeros(1,1600);
stds = zeros(1,1600);

for c = 1:1600
    means(c) = mean(double(data(:,c)));
    stds(c) = std(double(data(:,c)));
end

meanArray = repmat(means, size(data,1), 1);
stdArray = repmat(stds, size(data,1), 1);

% non standard data
oldData = double(data);
% standard data
newData = double(data);


newData = newData - double(meanArray);
newData = newData ./ stdArray;

oldCovMatrix = cov(oldData);
covMatrix  = cov(newData);

oldEigenVV = eig(covMatrix);
eigenVV = eig(covMatrix);

[oldEigenVectors,oldEigenValues] = eig(oldCovMatrix);
[eigenVectors,eigenValues] = eig(covMatrix);

oldSumEigen = sum(oldEigenVV);
sumEigen = sum(eigenVV);

disp(sum(eigenVV(1563:1600))/sumEigen)


x = 0;
k = 0;
for c = 1600:-1:1
   k = k +1;
   x = x + eigenVV(c);
   if(x / sumEigen >= 0.95)
       break;
   end
end
K = 1601-k;


a = 0;
b = 0;
for c = 1600:-1:1
   b = b +1;
   a = a + oldEigenVV(c);
   if(a / oldSumEigen > 0.95)
       break;
   end
end

B = 1601 - b;


disp(strcat("The value of k for the non standard data is: ",num2str(b)));
disp(strcat("The value of k for standard data is: ", num2str(k)));

%imshow(reshape(eigenVectors(:,1600),[40,40]),[min(eigenVectors(:,1600)), max(eigenVectors(1,1600))]);

% k PC
X = newData * eigenVectors(:,K:1600);
X = X * (eigenVectors(:,K:1600).');

oldX = oldData * oldEigenVectors(:,B:1600);
oldX = oldX * (oldEigenVectors(:,B:1600).');


% Single PC
Y= newData * eigenVectors(:,1600);
Y = Y * (eigenVectors(:,1600).');

oldY = oldData * oldEigenVectors(:,1600);
oldY = oldY * (oldEigenVectors(:,1600).');


subplot(2,3,1), imshow(reshape(oldData(1,:), [40,40]), [min(oldData(1,:)), max(oldData(1,:))]);
title('Original');

subplot(2,3,2), imshow(reshape(oldY(1,:), [40,40]), [min(oldY(1,:)),max(oldY(1,:))]);
title('Single PC Reconstruction');

subplot(2,3,3), imshow(reshape(oldX(1,:), [40,40]), [min(oldX(1,:)),max(oldX(1,:))]);
title(strcat(num2str(b),' PC Reconstruction'));


subplot(2,3,4), imshow(reshape(newData(1,:), [40,40]), [min(newData(1,:)), max(newData(1,:))]);
title('Original');

subplot(2,3,5), imshow(reshape(Y(1,:), [40,40]), [min(Y(1,:)),max(Y(1,:))]);
title('Single PC Reconstruction');

subplot(2,3,6), imshow(reshape(X(1,:), [40,40]), [min(X(1,:)),max(X(1,:))]);
title(strcat(num2str(k),' PC Reconstruction'));

figure, subplot(1,2,1), imshow(reshape(oldEigenVectors(:,1600),[40,40]),[min(oldEigenVectors(:,1600)),max(oldEigenVectors(:,1600))]);
title('PCA visualization with non standardized data');

subplot(1,2,2), imshow(reshape(eigenVectors(:,1600),[40,40]),[min(eigenVectors(:,1600)),max(eigenVectors(:,1600))]);
title('PCA visualization with standardized data');