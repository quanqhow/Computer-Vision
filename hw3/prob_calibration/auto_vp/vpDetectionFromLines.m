function [VP, lineLabel] = vpDetectionFromLines(lines)

%% Simple vanishing point detection using RANSAC
% === Input === 
% lines: [NumLines x 5]
%   - each row is a detected line segment (x1, y1, x2, y2, length)
% 
% === Output ===
% VP: [2 x 3]
%   - each column corresponds to a vanishing point in the order of X, Y, Z
% lineLabel: [NumLine x 3] logical type
%   - each column is a logical vector indicating which line segments
%     correspond to the vanishing point.

%%
%%
%random line points selection
N = size(lines,1);
rand1 = randperm(N);
rand2 = randperm(N);
uniqueLines = rand1~=rand2;

line1 = lines(uniqueLines,:);
line2 = lines(uniqueLines,:);

line1XY  = convertLinetoXY(line1);
line2XY  = convertLinetoXY(line2);

A = zeros(2,2);
b = [-1;-1];
vp = zeros(size(uniqueLines,2), 2);
for i = 1:size(uniqueLines,2)
    A(1,:) = line1XY(i,:);
    A(2,:) = line2XY(i,:);
    vp(i,:) = b\A;
    
end

% JLinkage clustering
% http://www.diegm.uniud.it/fusiello/demo/jlk/
lineLabel = clusterLineSeg(PrefMat);


end

function lineLabel = clusterLineSeg(PrefMat)

numVP = 3;

T = JLinkageCluster(PrefMat);
numCluster = length(unique(T));
clusterCount = hist(T, 1:numCluster);
[~, I] = sort(clusterCount, 'descend');

lineLabel = false(size(PrefMat,1), numVP);
for i = 1: numVP
    lineLabel(:,i) = T == I(i);
end

end

function [T, Z, Y] = JLinkageCluster(PrefMat)

Y = pDistJaccard(PrefMat');
Z = linkageIntersect(Y, PrefMat);
T = cluster(Z,'cutoff',1-(1/(size(PrefMat,1)))+eps,'criterion','distance');

end


function lineXY = convertLinetoXY(line)
numLines = size(line, 1);
linesXY  = zeros(numLines, 2);
A = zeros(2,2);
b = [-1;-1];
for i = 1: numLines
    A(1,:) = line(i,1:2);
    A(2,:) = line(i,3:4);
    lineXY(i,:) = A\b;
end
end
