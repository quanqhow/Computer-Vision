function [keyXs, keyYs] = getKeypoints(im, tau)
% Detecting keypoints using Harris corner criterion  

% im: input image
% tau: threshold

% keyXs, keyYs: detected keypoints, with dimension [Number of keypoints] x [2]

% YOUR CODE HERE
  
%% Smoothen the Image
    doubleIm = double(im);
    hD = fspecial('gaussian',10,2);
    smoothIm = imfilter(doubleIm,hD);
    subplot(3,4,1)
    imshow(im);
    subplot(3,4,2)
    imagesc(smoothIm)
    
%% Gradient Images
    [Ix,Iy] = gradient(smoothIm);
    subplot(3,4,3)
    imshow(Ix)
    subplot(3,4,4)
    imshow(Iy)
    
%% Compute gradients for H matrix
    IxIx = Ix.*Ix;
    IxIy = Ix.*Iy;
    IyIy = Iy.*Iy;
    
    subplot(3,4,5)
    imshow(IxIx)
    subplot(3,4,6)
    imshow(IxIy)
    subplot(3,4,7)
    imshow(IyIy)
    
 %% Localise the Gradients
    gau = fspecial('gaussian',10,3);
    A = imfilter(IxIx,gau);
    B = imfilter(IxIy,gau);
    C = imfilter(IyIy,gau);
    
    subplot(3,4,9)
    imshow(A)
    subplot(3,4,10)
    imshow(B)
    subplot(3,4,11)
    imshow(C)
    
 %% Harris Function = determinant/trace 
   
    
end