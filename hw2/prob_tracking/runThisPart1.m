im = imread('images/hotel.seq0.png');
tau = 0.5;
[keyXs, keyYs] = getKeypoints(im, tau);

figure(1);
imshow(im1);
hold on;
plot(keyYs,keyXs,'r.','linewidth',3);