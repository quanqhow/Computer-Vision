% function err_avg = evalAlignmentAll
tic
clear; clf;
imgPath = 'data';

objList = {'apple', 'bat', 'bell', 'bird', 'Bone', 'bottle', 'brick', ...
    'butterfly', 'camel', 'car', 'carriage', 'cattle', 'cellular_phone', ...
    'chicken', 'children', 'device7', 'dog', 'elephant', 'face', 'fork', 'hammer', ...
    'Heart', 'horse', 'jar', 'turtle'};

%objList = {'hammer'}

numObj = length(objList);

err_align = zeros(numObj, 1);

figure(1);
ha = tight_subplot(5,5,[.01 .03],[.1 .01],[.01 .01]);
for i = 1 : numObj
    objName = objList{i};
    % Load image pair
    im1 = imread(fullfile(imgPath, [objName, '_1.png']));
    im2 = imread(fullfile(imgPath, [objName, '_2.png']));
    
    % Alignment
    newim1 = checkBestFit(im1,im2);     
    
	% You code this
    T1 = align_shape( newim1, im2 );
    T2 = align_shape( im1, im2 );
    
    aligned1 = imtransform(newim1, maketform('projective', double(T1')), ...
        'XData',[1 size(newim1,2)],'YData',[1 size(newim1,1)]);
    
    aligned2 = imtransform(im1, maketform('projective', double(T2')), ...
        'XData',[1 size(im1,2)],'YData',[1 size(im1,1)]);
    
    if evalAlignment(im2, aligned1) > evalAlignment(im2, aligned2)
        aligned = aligned2;
    else
        aligned = aligned1;
    end;
    % display alignment
    axes(ha(i));
    
    c = double(repmat(im1, [1 1 3]));
    c(:,:,2) = im2; c(:,:,3) = aligned;
    imshow(c);
    
    % Display errors
    err_align_original(i) = evalAlignment(im2, aligned2);
    err_align(i) = evalAlignment(im2, aligned);
    fprintf('Error for aligning "%s": %f\n', objName, err_align(i));
end

% Export results
figure(2); 
subplot(2,1,2);
bar(err_align,'b');
set(gca, 'XTick', 1:numObj);
set(gca, 'XTickLabel', objList, 'FontSize', 12);
xlabel('Object', 'FontSize', 8);
ylabel('Alignment error', 'FontSize', 16);

subplot(2,1,1);
bar(err_align_original,'r');
set(gca, 'XTick', 1:numObj);
set(gca, 'XTickLabel', objList, 'FontSize', 12);
xlabel('Object', 'FontSize', 16);
ylabel('Alignment error', 'FontSize', 8);
fprintf('Averaged alignment error = %f\n', mean(err_align));
% end
toc