% insert Segmented Image into the 

load cat_mask.mat

imNew = imread('hp.jpg');
size(imNew);

im = imresize(im,0.3);
im(im>=1) = 1
labels = imresize(labels,0.3);
labels = ~labels
figure(1);
image(im);

figure(2);
imagesc(labels);

figure(3);
imagesc(imNew);
im = round(im.*255)
[H W N] = size(im);
for i=1:3    
    sampleImNew = imNew(40:40+H-1,40:40+W-1,i);
    sampleIm = im(:,:,i);
    sampleImNew(sampleImNew&labels) = sampleIm(sampleImNew&labels);
    imNew(40:40+H-1,40:40+W-1,i) = sampleImNew;
end;
figure(4);
imshow(imNew);

