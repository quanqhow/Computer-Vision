function T = align_shape(im1, im2)

    % im1: input edge image 1
    % im2: input edge image 2

    % Output: transformation T [3] x [3]
    
    % YOUR CODE　HERE

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
    T = Tr;
    
    im1Temp = [x1 y1 ones(numel(x1),1)];
    im1Temp = im1Temp';
    im2Temp = [x2 y2 ones(numel(x2),1)];
    im2Temp = im2Temp';
    for i = 1:25
        im1TempNew = T*im1Temp;
        [D, I] = pdist2(im2Temp',im1TempNew','euclidean','Smallest',1);
        
        A = im1TempNew;
        b1 = im2Temp(1,I);
        if rank(A) >= 3 
            %mx = A'\b1';
            [mx, flag] = lsqr(A',b1');
        else
            mx = [1 0 0];
        end
        m1 = mx(1);
        m2 = mx(2);
        t1 = mx(3);
        
        b2 = im2Temp(2,I);
        if rank(A) >= 3 
            %my = A'\b2';
            [my, flag] = lsqr(A',b2');
        else
            my = [1 0 0];
        end
        m3 = my(1);
        m4 = my(2);
        t2 = my(3);
        
        newT = T*[m1 m2 t1;m3 m4 t2;0 0 1];        
        if rank(newT)>=3 && cond(newT)< 1e+06
            T = newT;
        else
            T = T;
            break;
        end
    end
    
    
        
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
