function [keyXs, keyYs] = getKeypoints(im, tau)
% Detecting keypoints using Harris corner criterion  

% im: input image
% tau: threshold

% keyXs, keyYs: detected keypoints, with dimension [Number of keypoints] x [2]

% YOUR CODE HERE
  
%% Smoothen the Image
     doubleIm = double(im);
%     hD = fspecial('gaussian',10,2);
%     smoothIm = imfilter(doubleIm,hD);
%     subplot(3,4,1)
%     imshow(im);
%     subplot(3,4,2)
%     imagesc(smoothIm);
    
%% Gradient Images
    [Ix,Iy] = gradient(doubleIm);
%     subplot(3,4,3)
%     imshow(Ix);
%     subplot(3,4,4)
%     imshow(Iy);
    
%% Compute gradients for H matrix
    IxIx = Ix.*Ix;
    IxIy = Ix.*Iy;
    IyIy = Iy.*Iy;
    
%     subplot(3,4,5)
%     imshow(IxIx);
%     subplot(3,4,6)
%     imshow(IxIy);
%     subplot(3,4,7)
%     imshow(IyIy);
    
 %% Localise the Gradients
    gau = fspecial('gaussian',30,10);
    A = imfilter(IxIx,gau);
    B = imfilter(IxIy,gau);
    C = imfilter(IyIy,gau);
    
%     subplot(3,4,9)
%     imshow(A);
%     subplot(3,4,10)
%     imshow(B);
%     subplot(3,4,11)
%     imshow(C);
    
 %% Harris Function = determinant/trace 
    [l b] = size(A);
    H = (A.*C - B.*B)./(A+C);
   
    normH = H-min(min(H));
    normH = normH./(max(max(H)));
    
 %% Non Maximum Suppression
    nonMaxNormH = normH;
    nonMaxNormH(find(normH ~= ordfilt2(normH,9,ones(3)))) = 0;
    
    [keyXs, keyYs] = find(nonMaxNormH > tau ); 
end