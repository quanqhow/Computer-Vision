% Load image and convert to floating point number format
% The image should be at least 640x480 pixels
%%
close all;
clear all;
clc;

im = rgb2gray(imread('bird.jpg'));
im = im2single(im);
N=5;
%im1 = load('im.mat')
%im = im1.im


%%
% Implement pyramidsGL
[G, L] = pyramidsGL(im, N);

%%
% Implement displayPyramids, you also need to implement displayFFT
% and call it in this function. You will find tight_subplot useful.
%displayPyramids(G, L);
figure(1);
displayPyramids(G, L);
%%
figure(2);
colormap('jet')
displayFFTs(G, L);

%% Graduate Credit Points
%% Reconstruction of the Pyramid.

figure(3)
tightSubPlot = tight_subplot(3,N,[.05 .05],[.1 .05],[.01 .01]);

for i = 1:N
    axes(tightSubPlot(i));
    imshow(G{i});
    title(sprintf('Gaussian of Level %d',i+1));

    axes(tightSubPlot(i+N));
    imshow(mat2gray(L{i}));
    title(sprintf('Laplacian of Level %d',i));
    
    G_test = G{i};
    L_test = L{i};
    upsample = imresize(G_test, 2);
    [b h] = size(L_test);
    reconTemp = L_test(1:b,1:h)+upsample(1:b,1:h);
    recon{i} = {reconTemp};
    axes(tightSubPlot(i+(2*N)));
    imshow(reconTemp);
    title(sprintf('Reconstructed Level %d',i));
    
    if i ~= 1
        [b h] = size(G{i-1});
        mse = reconTemp(1:b,1:h) - G{i-1}(1:b,1:h);        
    else
        [b h] = size(im);
        mse = reconTemp(1:b,1:h) - im(1:b,1:h);
    end;
    mse = mse.^2;
    mse = sqrt(mean(mean(mse)));
    error(i) = mse;
        
end

