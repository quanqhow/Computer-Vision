randIndex = randsample(size(inliers,2),1);
pandu = inliers(randIndex);
matchesIM = matches(pandu,:);
x1 = c1(matchesIM(1))
x2 = c2(matchesIM(2))
y1 = r1(matchesIM(1))
y2 = r2(matchesIM(2))

figure(5)
%imshow(im1);
hold on;
scatter(x1,y1,'r');

lineF = unitF * [x2 y2 1]';
x = 1:550;
y = -(lineF(1)*x + lineF(3))/lineF(2);

plot(x,y)
