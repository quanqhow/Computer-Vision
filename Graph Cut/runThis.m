% Add path
addpath(genpath('GCmex1.5'));
im = im2double( imread('pikachu.jpg') );

org_im = im;

H = size(im, 1); W = size(im, 2); K = 3;
parameters = 4;

% Load the mask
%load cat_poly
%load bird_poly
load pikachu_poly
inbox = poly2mask(poly(:,1), poly(:,2), size(im, 1), size(im,2));
% 1) Fit Gaussian mixture model for foreground regions
rF = im(:,:,1);
rF = rF(logical(inbox));
gF = im(:,:,2);
gF = gF(logical(inbox));
bF = im(:,:,3);
bF = bF(logical(inbox));

imF = zeros(size(rF,1),3);
imF(:,1) = rF(:);
imF(:,2) = gF(:);
imF(:,3) = bF(:);

gmmF = gmdistribution.fit(imF,parameters);
pdfF = pdf(gmmF,reshape(im,[H*W K]));
pdfF = reshape(pdfF,[H W]);
logPdfF = -log(pdfF);

colormap jet
figure(1);
subplot(1,2,1);
imagesc(pdfF);
title('Foreground');

figure(2);
subplot(2,1,1);
image(logPdfF);

% 2) Fit Gaussian mixture model for background regions
rB = im(:,:,1);
rB = rB(~logical(inbox));
gB = im(:,:,2);
gB = gB(~logical(inbox));
bB = im(:,:,3);
bB = bB(~logical(inbox));

imB = zeros(size(rB,1),3);
imB(:,1) = rB(:);
imB(:,2) = gB(:);
imB(:,3) = bB(:);

gmmB = gmdistribution.fit(imB,parameters);
pdfB = pdf(gmmB,reshape(im,[H*W K]));
pdfB = reshape(pdfB,[H W]);
logPdfB =-log(pdfB);

figure(1);
subplot(1,2,2);
imagesc(pdfB)
title('Background');

figure(2);
subplot(2,1,2);
image(logPdfB)

% 3) Prepare the data cost
% - data [Height x Width x 2] 
% - data(:,:,1) the cost of assigning pixels to label 1
% - data(:,:,2) the cost of assigning pixels to label 2
data = zeros(H,W,2);
data(:,:,1) = logPdfF;
data(:,:,2) = logPdfB;

% 4) Prepare smoothness cost
% - smoothcost [2 x 2]
% - smoothcost(1, 2) = smoothcost(2,1) => the cost if neighboring pixels do not have the same label
smoothcost = [0 10;10 0];

% 5) Prepare contrast sensitive cost
% - vC: [Height x Width]: vC = 2-exp(-gy/(2*sigma)); 
% - hC: [Height x Width]: hC = 2-exp(-gx/(2*sigma));
sigma = 0.001;
r = im(:,:,1);
g = im(:,:,2);
b = im(:,:,3);

[rx ry] = gradient(r);
[gx gy] = gradient(g);
[bx by] = gradient(b);
gx = sqrt(rx.^2+gx.^2+bx.^2);
gy = sqrt(ry.^2+gy.^2+by.^2);

%imGray = rgb2gray(im);
%[gx gy] = gradient(imGray);
vc = 2-exp(-gy/(2*sigma));
hc = 2-exp(-gx/(2*sigma));

% 6) Solve the labeling using graph cut
% - Check the function GraphCut
gch = GraphCut('open',data,smoothcost,vc,hc);
[gch labels] = GraphCut('expand',gch,100);
% 7) Visualize the results


r(labels==1) = 0;

g = im(:,:,2);
g(labels==1) = 0;

b = im(:,:,3);
b(labels==1) = 1;


imSeg = zeros(H,W,3);
imSeg(:,:,1) = r;
imSeg(:,:,2) = g;
imSeg(:,:,3) = b;

figure(3);
imshow(imSeg);