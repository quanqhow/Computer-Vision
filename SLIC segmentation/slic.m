function [cIndMap, time, imgVis] = slic(img, K, compactness)

%% Implementation of Simple Linear Iterative Clustering (SLIC)
%
% Input:
%   - img: input color image
%   - K:   number of clusters
%   - compactness: the weights for compactness
% Output: 
%   - cIndMap: a map of type uint16 storing the cluster memberships
%     cIndMap(i, j) = k => Pixel (i,j) belongs to k-th cluster
%   - time:    the time required for the computation
%   - imgVis:  the input image overlaid with the segmentation

% Put your SLIC implementation here



tic;
% Input data
imgB   = im2double(img);
cform  = makecform('srgb2lab');
imgLab = applycform(imgB, cform);
    
% Initialize cluster centers (equally distribute on the image). Each cluster is represented by 5D feature (L, a, b, x, y)
% Hint: use linspace, meshgrid
[rows cols ~] = size(imgLab);
S = round(sqrt(rows*cols/K));
W = (compactness.^2)/(S.^2);

cIndMap = -ones(rows,cols);
clusterRows = linspace(1,rows,round(sqrt(K))+2);
clusterCols = linspace(1,cols,round(sqrt(K))+2);
[X Y] = meshgrid(clusterRows,clusterCols);
clusters = [X(:) Y(:)];
labxy = zeros(size(clusterRows,2),size(clusterCols,2),5);

%init cluster centres
for i = 1:size(clusterRows,2)
    for j = 1:size(clusterCols,2)        
        labxy(i,j,:) = getLABXY(imgLab,clusterCols,clusterRows,i,j);
    end
end
% SLIC superpixel segmentation
% In each iteration, we update the cluster assignment and then update the cluster center
dist = 1e7*ones(rows,cols);
numIter  = 10; % Number of iteration for running SLIC
for iter = 1: numIter
	% 1) Update the pixel to cluster assignment
    for i = 1:size(clusters,1)	
        %for each cluster centre        
        clusterRow = mod(i,size(X,1));
        clusterCol = ceil(i/size(X,1));
        if clusterRow == 0
            clusterRow = size(X,1);
        end
        labxyCentre = labxy(clusterRow,clusterCol,:);
        gridX = clusters(i,1)-S:clusters(i,1)+S;
        gridY = clusters(i,2)-S:clusters(i,2)+S;
        gridX = ceil(gridX(find(gridX>0 & gridX<rows)));
        gridY = ceil(gridY(find(gridY>0 & gridY<cols)));
        
        
        patchL = imgLab(gridX,gridY,1);
        patchA = imgLab(gridX,gridY,2);
        patchB = imgLab(gridX,gridY,3);
        [patchX patchY] = meshgrid(gridY,gridX);
        
        distL = (patchL - labxyCentre(1)).^2;
        distA = (patchA - labxyCentre(2)).^2;
        distB = (patchB - labxyCentre(3)).^2;
        distX = (patchX - labxyCentre(4)).^2;
        distY = (patchY - labxyCentre(5)).^2;
             
        currDist = dist(gridX,gridY);
        currCIndMap = cIndMap(gridX,gridY);
        
        newDist = distL+distA+distB+distX.*W*0.1+distY.*W*0.10;
        
        newDistInd = find(newDist<currDist);
        
        currDist(newDistInd) = newDist(newDistInd);
        currCIndMap(newDistInd) = i;
        cIndMap(gridX,gridY) = currCIndMap;
        dist(gridX,gridY) = currDist;
        
        
    end
	% 2) Update the cluster center by computing the mean
    
    for i = 1:size(clusters,1)
        clusterRow = mod(i,size(X,1));
        clusterCol = ceil(i/size(X,1));
        if clusterRow == 0
            clusterRow = size(X,1);
        end
        [getIndx getIndy] = find(cIndMap==i);
        meanL = sum(imgLab(sub2ind(size(imgLab),getIndx,getIndy,ones(size(getIndx,1),1))))/size(getIndx,1);
        meanA = sum(imgLab(sub2ind(size(imgLab),getIndx,getIndy,2*ones(size(getIndx,1),1))))/size(getIndx,1);
        meanB = sum(imgLab(sub2ind(size(imgLab),getIndx,getIndy,3*ones(size(getIndx,1),1))))/size(getIndx,1);
        meanX=mean(getIndx);
        meanY=mean(getIndy);
        labxy(clusterRow,clusterCol,:) = [meanL, meanA, meanB, meanX, meanY];
        clusters(i,:) = [meanX,meanY];        
    end


end

time = toc


% Visualize mean color image
[gx, gy] = gradient(cIndMap);
bMap = (gx.^2 + gy.^2) > 0;
imgVis = img;
imgVis(cat(3, bMap, bMap, bMap)) = 1;
figure(1)
imshow(imgVis)

cIndMap = uint16(cIndMap);
figure(2)
imagesc(cIndMap)

end

function labxy = getLABXY(imgLab,clusterCols,clusterRows,i,j)
        l = interp2(imgLab(:,:,1),clusterCols(i),clusterRows(j));
        a = interp2(imgLab(:,:,2),clusterCols(i),clusterRows(j));
        b = interp2(imgLab(:,:,3),clusterCols(i),clusterRows(j));
        x = clusterRows(i);
        y = clusterCols(j);
        labxy = [l a b x y];
end