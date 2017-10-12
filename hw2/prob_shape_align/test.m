a = zeros(5,5);

a(:,1) = [1,2,5,2,9]

for i=2:5
    a(:,i) = a(:,i-1)+1
end
plot(a(:,1),1:5)



