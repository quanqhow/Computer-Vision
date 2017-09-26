function [mag,theta] = orientedFilterMagnitude(im) ;

    im = cast(im,'double');
%     figure(1);
%     subplot(2,4,1);
%     image(im/255);
    
    %filtering the image with Gaussian
    filterGaussian = fspecial('Gaussian',9,3);
%     subplot(2,4,2);
%     imagesc(filterGaussian);
    
    filterImage = imfilter(im,filterGaussian);
%     subplot(2,4,3);
%     imagesc(filterImage/255);
    
    %Finding Gradient in x and y directions
    grad1 = imfilter(filterImage,[-0.5,0,0.5]);
    grad2 = imfilter(filterImage,[-0.5,0,0;0,0,0;0,0,0.5]);
    grad3 = imfilter(filterImage, [-0.5;0;0.5]);
    grad4 = imfilter(filterImage,[0,0,0.5;0,0,0;-0.5,0,0]);
%     subplot(2,4,5);
%     imagesc((grad1+255)/511);
%     
%     subplot(2,4,6);
%     imagesc((grad2+255)/511);
%     
%     subplot(2,4,7);
%     imagesc((grad3+255)/511);
%     
%     subplot(2,4,8);
%     imagesc((grad4+255)/511);

    %Creating a 4-d Array with  different gradients
    grad(:,:,:,1) = grad1;
    grad(:,:,:,2) = grad2;
    grad(:,:,:,3) = grad3;
    grad(:,:,:,4) = grad4;
    
    %taking max of the 4-d array along the 4th dimension to get the best
    %gradient amongst the 4 orientations
    
    grad = max(abs(grad),[],4);
    %size(grad)
%     subplot(2,4,4);
%     imagesc((grad+100)/355);
    
    %L2 Norm of R,G,B Planes
    mag = sqrt(grad(:,:,1).^2+grad(:,:,2).^2+grad(:,:,3).^2);
%     subplot(2,4,5);
%     colormap('gray');
%     imshow(grad/255);
    
    %getchannel with the largest gradient magnitude 
    [maxGrad, maxGradIndex] = max(grad,[],3);
    [sizeL,sizeB,sizeH] = size(grad1);
    N = sizeL*sizeB;
    
    %compute theta
    num = grad3((1:N) + (maxGradIndex(:)'-1)*N) + grad4((1:N) + (maxGradIndex(:)'-1)*N)/sqrt(2) - grad2((1:N) + (maxGradIndex(:)'-1)*N)/sqrt(2);
    den = grad1((1:N) + (maxGradIndex(:)'-1)*N) + grad4((1:N) + (maxGradIndex(:)'-1)*N)/sqrt(2) + grad2((1:N) + (maxGradIndex(:)'-1)*N)/sqrt(2);

    theta = atan2(num,den);
    theta = reshape(theta,sizeL,sizeB);
%     subplot(2,4,6);
%     imagesc(theta/255);
    
end