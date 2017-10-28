
% Matching SIFT Features

im1 = imread('stop1.jpg');
im2 = imread('stop2.jpg');

load('SIFT_features.mat'); % Load pre-computed SIFT features
% Descriptor1, Descriptor2: SIFT features from image 1 and image 2
% Frame1, Frame2: position, scale, rotation of keypoints

% YOUR CODE HERE
tic
[D, I] = pdist2(Descriptor2',Descriptor1','euclidean','Smallest',2);
toc

tic
mdl = createns(Descriptor1','NSMethod','kdtree');
in = knnsearch(mdl,Descriptor2','K',2);
toc

% im1test = find(D(1,:)/max(D(1,:))>0.9);
im2test = find(D(1,:)./D(2,:)<0.5);
% matches: a 2 x N array of indices that indicates which keypoints from image
% 1 match which points in image 2
%matches =  [1:597;I(1,:)];
matches1 =  [im1test;I(1,im1test)];
matches2 =  [im2test;I(1,im2test)];
% Display the matched keypoints
figure(1), hold off, clf
% plotmatches(im2double(im1),im2double(im2),Frame1,Frame2,matches1);
plotmatches(im2double(im1),im2double(im2),Frame1,Frame2,matches2);

figure(2); hold off, clf
matches = [[380:2:400]',in(380:2:400,1)];
plotmatches(im2double(im1),im2double(im2),Frame1,Frame2,matches');