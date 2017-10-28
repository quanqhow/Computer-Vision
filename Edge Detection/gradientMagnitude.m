function [mag, theta] = gradientMagnitude(im, sigma)
    
    im = cast(im,'double');
%     figure(1);
%     subplot(2,4,1);
%     image(im/255);
    
    %filtering the image with Gaussian
    filterGaussian = fspecial('Gaussian',3*sigma,sigma);
%     subplot(2,4,2);
%     imagesc(filterGaussian);
    
    filterImage = imfilter(im,filterGaussian);
%     subplot(2,4,3);
%     imagesc(filterImage/255);
    
    %Finding Gradient in x and y directions
    gradX = imfilter(filterImage,[-0.5,0,0.5]);
    gradY = imfilter(filterImage,[-0.5;0;0.5]);
    
    %L2 Norm of the x and y gradients
    grad = sqrt(gradX.^2 + gradY.^2);
%     subplot(2,4,4);
%     imagesc(grad/255);
    
    %L2 Norm of R,G,B Planes
    mag = sqrt(grad(:,:,1).^2+grad(:,:,2).^2+grad(:,:,3).^2);
%     subplot(2,4,5);
%     colormap('gray');
%     imagesc(grad/255);
    
    %getchannel with the largest gradient magnitude 
    [maxGrad, maxGradIndex] = max(grad,[],3);
    [sizeL,sizeB,sizeH] = size(gradY);
    N = sizeL*sizeB;
    
    %compute theta
    theta = atan2(gradY((1:N) + (maxGradIndex(:)'-1)*N), gradX((1:N) + (maxGradIndex(:)'-1)*N));
    theta = reshape(theta,sizeL,sizeB);
%     subplot(2,4,6);
%     imagesc(theta/255);
end