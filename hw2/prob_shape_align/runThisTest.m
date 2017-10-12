function runThisTest
im1 = imread('data/bottle_1.png');
im2 = imread('data/bottle_2.png');

[y1 x1] = find(im1>0);
[y2 x2] = find(im2>0);

[x1mean y1mean var1] = getMeanVar(x1,y1);
[x2mean y2mean var2] = getMeanVar(x2,y2);

% Translation and Scaling
t1 = [1 0 x2mean;0 1 y2mean;0 0 1];
t2 = [(var2/var1) 0 0;0 (var2/var1) 0;0 0 1];
t3 = [1 0 -x1mean;0 1 -y1mean;0 0 1];
Tr = t1*t2*t3;

% Rotation
theta = getAngle(x1,y1,x2,y2);

R = [cos(theta) -sin(theta) 0;sin(theta) cos(theta) 0;0 0 1];
det(Tr)
T = R*Tr;


aligned = imtransform(im1, maketform('projective', double(T')), ...
        'XData',[1 size(im1,2)],'YData',[1 size(im1,1)]);
    toc
    
    % display alignment
    figure(2)
    c = double(repmat(im1, [1 1 3]));
    c(:,:,2) = im2; c(:,:,3) = aligned;
    imshow(c);
    
    % Display errors
    err_align = evalAlignment(im2, aligned);
    fprintf('Error for aligning "%s": %f\n', 'thisPanduImage', err_align);

end

function [x y var] = getMeanVar(x1,y1)
    x = mean(x1);
    y = mean(y1);
    var = sqrt(sum((x1-x).^2) + sum((y1-y).^2))/numel(x);    
end

function theta = getAngle(x1,y1,x2,y2)
    covar1 = cov([x1 y1]);
    covar2 = cov([x2 y2]);
    maxEigenVector1 = getMaxEigenValue(covar1);
    maxEigenVector2 = getMaxEigenValue(covar2);
    
    theta = -atan(maxEigenVector2(1)/maxEigenVector2(2)) + atan(maxEigenVector1(1)/maxEigenVector1(2));    
end

function maxEigenVector = getMaxEigenValue(covar)
    [eigenVector eigenCovar] = eig(covar);
    if eigenCovar(1,1)>eigenCovar(2,2)
        maxEigenVector = eigenVector(:,1);
    else
        maxEigenVector = eigenVector(:,2);
    end
    
end