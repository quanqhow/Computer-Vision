figure(5)
subplot(1,4,4)
h = fspecial('gaussian',9,3)
imagesc(h)
g1 = imfilter(h,[-0.5,0,0.5])
subplot(1,4,1)
imagesc(g1)
title('Gradient Filter 1')


g2 = imfilter(h,[-0.5,0,0;0,0,0;0,0,0.5])
subplot(1,4,2)
imagesc(g2)
title('Gradient Filter 2')


g3 = imfilter(h,[-0.5;0;0.5])
subplot(1,4,3)
imagesc(g3)
title('Gradient Filter 3')

g4 = imfilter(h,[0,0,0.5;0,0,0;-0.5,0,0])
subplot(1,4,4)
imagesc(g4)
title('Gradient Filter 4')