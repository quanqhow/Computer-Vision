function newim1 = checkBestFit(im1,im2);
    
    minEval = evalFit(im1,im2);
    newim1 = im1;
    
    for i = 1:4
        tempim1 = imrotate(im1,90*i);
        if evalFit(tempim1,im2) < minEval
            newim1 = tempim1;
            minEval = evalFit(tempim1,im2);
        end
    end
    
    tempim1 = flipdim(im1,1);
    if evalFit(tempim1,im2) < minEval
            newim1 = tempim1;
            minEval = evalFit(tempim1,im2);
    end    
   
    tempim1 = flipdim(im1,2);
    if evalFit(tempim1,im2) < minEval
            newim1 = tempim1;
            minEval = evalFit(tempim1,im2);
    end
    
    
    tempim1 = flipdim(flipdim(im1,1),2);
    if evalFit(tempim1,im2) < minEval
            newim1 = tempim1;
            minEval = evalFit(tempim1,im2);
    end
    
  
    
    newim1 = imresize(newim1,[size(im1,1) size(im2,2)]);
       
end

function eval = evalFit(im1,im2)
    [y1 x1] = find(im1>0);
    [y2 x2] = find(im2>0);
    [D, I] = pdist2([y1 x1],[y2 x2],'euclidean','Smallest',1);
    eval = sum(D);
end
