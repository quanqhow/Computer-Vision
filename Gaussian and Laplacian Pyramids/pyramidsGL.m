% Using the kernel specified on page 533 of the follwing paper "The
% Laplacian Pyramid as a Compact Image Code" in  IEEE Transactions on 
% Communications, vol. COM-31, no. 4, April 1983

% Using a = 0.375
function [G,L] = pyramidsGL(im, N)
    a0 = 0.375;
    a1 = 1/4;
    a2 = (1/4) - (a0/2);
    gaussianKernel = [a2 a1 a0 a1 a2];
    gaussianKernel = gaussianKernel'*gaussianKernel;
    inputImage = double(im);
    for i = 1:N
        %filterOutput = imfilter(inputImage,gaussianKernel);        
        %[len,bth] = size(filterOutput);
        %downsize = filterOutput(1:2:len,1:2:bth);
        [len,bth] = size(inputImage);
        % If the number of rows/columns are not even, we are adding one
        % extra coloumn which is replicated from the last index
        if (mod(len,2) ~= 0)
            inputImage = [inputImage; inputImage(len,:)];
        end
        
        if (mod(bth,2) ~= 0)
            inputImage = [inputImage, inputImage(:,bth)];
        end
        
        downsize = imresize(inputImage, 0.5, 'bilinear');        
        G(i) = {downsize};
        %upsize = zeros(len,bth);
        upsize = imresize(downsize, 2, 'bilinear');
        upsize = inputImage - upsize;
        %upsize = inputImage - imfilter(upsize,gaussianKernel);
        L(i) = {upsize};
        inputImage = downsize;
    end
end