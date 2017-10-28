function F = HW3_FundamentalMatrix
close all;

im1 = im2double(imread('chapel00.png'));
im2 = im2double(imread('chapel01.png'));
load 'matches.mat';

[F, inliers, normalF, normalInliers] = ransacF(c1(matches(:, 1)), r1(matches(:, 1)), c2(matches(:, 2)), r2(matches(:, 2)), im1, im2);

% display F
F;
normalF;
unitF1 = F/sqrt(sum(sum(F.^2)))
unitF2 = normalF/sqrt(sum(sum(normalF.^2)))
outliers1 = setdiff(1:size(matches,1),inliers);
outliers2 = setdiff(1:size(matches,1),normalInliers);

size(outliers1)
size(outliers2)
% plot outliers
figure(1)
plotmatches(im1,im2,[c1 r1]',[c2 r2]',matches');
figure(2)
plotmatches(im1,im2,[c1 r1]',[c2 r2]',matches(inliers,:)');

figure(7)
plotmatches(im1,im2,[c1 r1]',[c2 r2]',matches');
figure(8)
plotmatches(im1,im2,[c1 r1]',[c2 r2]',matches(normalInliers,:)');



% display epipolar lines
randIndex = randsample(size(inliers,2),7);
pointsToPlot1 = inliers(randIndex);

randIndex = randsample(size(normalInliers,2),7);
pointsToPlot2 = normalInliers(randIndex);

figure(3)
imshow(im1);
hold on;

figure(9)
imshow(im1);
hold on;

figure(4)
imshow(im2);
hold on;

figure(10)
imshow(im2);
hold on;
for i = 1:size(pointsToPlot1,2)
    matchesIM = matches(pointsToPlot1(i),:);
    x1 = c1(matchesIM(1));
    x2 = c2(matchesIM(2));
    y1 = r1(matchesIM(1));
    y2 = r2(matchesIM(2));

    

    lineF1 = unitF1 * [x2 y2 1]';
    lineF2 = unitF1 * [x1 y1 1]';
    x1Line = 1:0.1:550;
    y1Line = -(lineF1(1)*x1Line + lineF1(3))/lineF1(2);    

    x2Line = 1:0.1:550;
    y2Line = -(lineF2(1)*x2Line + lineF2(3))/lineF2(2);
    
    figure(3)    
    hold on;
    scatter(x1,y1,'r+');
    plot(x1Line,y1Line,'g');

    figure(4)   
    hold on;
    scatter(x2,y2,'r+');
    plot(x2Line,y2Line,'g');
end;

for i = 1:size(pointsToPlot2,2)
    matchesIM = matches(pointsToPlot2(i),:);
    x1 = c1(matchesIM(1));
    x2 = c2(matchesIM(2));
    y1 = r1(matchesIM(1));
    y2 = r2(matchesIM(2));

    

    lineF1 = unitF2 * [x2 y2 1]';
    lineF2 = unitF2 * [x1 y1 1]';
    x1Line = 1:0.1:550;
    y1Line = -(lineF1(1)*x1Line + lineF1(3))/lineF1(2);    

    x2Line = 1:0.1:550;
    y2Line = -(lineF2(1)*x2Line + lineF2(3))/lineF2(2);
    
    figure(9)    
    hold on;
    scatter(x1,y1,'r+');
    plot(x1Line,y1Line,'g');

    figure(10)   
    hold on;
    scatter(x2,y2,'r+');
    plot(x2Line,y2Line,'g');
end;

figure(5);
inlierPoints = matches(inliers,:);
outlierPoints = matches(outliers1,:);
imshow(im1);
hold on;
scatter(c1(outlierPoints(:,1)),r1(outlierPoints(:,1)),'g.')
scatter(c1(inlierPoints(:,1)),r1(inlierPoints(:,1)),'r.')


figure(11);
inlierPoints = matches(normalInliers,:);
outlierPoints = matches(outliers2,:);
imshow(im1);
hold on;
scatter(c1(outlierPoints(:,1)),r1(outlierPoints(:,1)),'g.')
scatter(c1(inlierPoints(:,1)),r1(inlierPoints(:,1)),'r.')
test=0;

error1 = [matches(inliers,:) ones(1,size(inliers,2))']*unitF1*[matches(inliers,:) ones(1,size(inliers,2))']';
error2 = [matches(normalInliers,:) ones(1,size(normalInliers,2))']*unitF2*[matches(normalInliers,:) ones(1,size(normalInliers,2))']';
error1 = trace(error1.^2)/size(inliers,2)
error2 = trace(error2.^2)/size(normalInliers,2)


function [bestF, best, normalF, normal] = ransacF(x1, y1, x2, y2, im1, im2)

% Find normalization matrix
T1 = normalize(x1, y1);
T2 = normalize(x2, y2);

% Transform point set 1 and 2
x1PtsTemp = [x1 y1 ones(size(x1))];
x2PtsTemp = [x2 y2 ones(size(x2))];

x1Pts = (T1*x1PtsTemp')';
x2Pts = (T2*x2PtsTemp')';
% RANSAC based 8-point algorithm
bestCountInliers1 = 2;
bestCountInliers2 = 2;
for i = 1:1000
    randIndex = randsample(size(x1,1),8);
    
    
    F1 = computeF(x1Pts(randIndex,:),x2Pts(randIndex,:));
    F2 = computeF(x1PtsTemp(randIndex,:),x2PtsTemp(randIndex,:));
    inliers1 = getInliers(x1Pts, x2Pts, F1, 0.1);
    inliers2 = getInliers(x1PtsTemp, x2PtsTemp, F2, 5);
    countInliers1(i) = size(inliers1,2);
    countInliers2(i) = size(inliers2,2);
    
    if countInliers1(i)>bestCountInliers1
        rightF1 = F1;
        rightInliers1 = inliers1;
        bestCountInliers1 = countInliers1(i);
        %figure(3), hold off, plotmatches(im1, im2, x1Pts(:, 1:2)', x2Pts(:, 1:2)', [inliers inliers]'); 
    end;
    
    if countInliers2(i)>bestCountInliers2
        rightF2 = F2;
        rightInliers2 = inliers2;
        bestCountInliers2 = countInliers2(i);
        %figure(3), hold off, plotmatches(im1, im2, x1Pts(:, 1:2)', x2Pts(:, 1:2)', [inliers inliers]'); 
    end;
end
bestF = T2'*rightF1*T1;
%bestF = T1'*rightF*T2;
best = rightInliers1;

normalF = rightF1;
normal = rightInliers2;



function inliers = getInliers(pt1, pt2, F, thresh)
% Function: implement the criteria checking inliers. 
for i = 1:size(pt1,1)
    lineTemp1 = F*pt1(i,:)';
    lineTemp2 = F*pt2(i,:)';
    pointDistanceX1(i) = abs(pt1(i,:)*lineTemp2)/sqrt(lineTemp2(1)^2+lineTemp2(2)^2);
    pointDistanceX2(i) = abs(pt2(i,:)*lineTemp1)/sqrt(lineTemp1(1)^2+lineTemp1(2)^2);

end

inliers = find(pointDistanceX1<thresh & pointDistanceX2<thresh);

function T = normalize(x, y)
% Function: find the transformation to make it zero mean and the variance as sqrt(2)
T = [1/std(x) 0 0 ; 0 1/std(y) 0 ; 0 0 1]*[1 0 -mean(x) ; 0 1 -mean(y) ; 0 0 1];

  
function F = computeF(x1,x2)
% Function: compute fundamental matrix from corresponding points
A = [x1(:,1).*x2(:,1) x1(:,1).*x2(:,2) x1(:,1) x1(:,2).*x2(:,1) x1(:,2).*x2(:,2) x1(:,2) x2(:,1) x2(:,2) ones(size(x1,1),1)];
[U, S, V] = svd(A);
f = V(:, end);
F = reshape(f, [3 3])';
[U, S, V] = svd(F);
S(3,3) = 0; 
F = U*S*V';


