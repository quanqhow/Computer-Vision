function featureTracking
% Main function for feature tracking
    folder = '.\images';
    im = readImages(folder, 0:10:10);

%     tau = 0.06;                                 % Threshold for harris corner detection
%     [pt_x, pt_y] = getKeypoints(im{1}, tau);    % Prob 1.1: keypoint detection
%     
    [pt_x,pt_y] = meshgrid(1:10:size(im{1},1)-1,1:10:size(im{1},2)-1);
    size1 = size(1:10:size(im{1},1)-1,2)
    track_flag = ones(1,numel(pt_x));
    ws = 25;                                     % Tracking ws x ws patches
    [track_x, track_y, track_flag] = ...                    % Keypoint tracking
        trackPoints(pt_x, pt_y, im, ws, track_flag);
    
    track_x_op = track_x(:,2)-track_x(:,1);
    track_y_op = track_y(:,1)-track_y(:,1);
    track_x_op = reshape(track_x_op(),size1,[]);
    track_y_op = reshape(track_y_op,size1,[]);
    
    tracker(:,:,1) = track_x_op;
    tracker(:,:,2) = track_y_op;
    
    flower = flowToColor(tracker)
    figure(6);
    imagesc(flower);
    %points going outside the figure
    track_out_x = track_x(find(track_flag==0),:);
    track_out_y = track_y(find(track_flag==0),:);
    
    track_in_x = track_x(find(track_flag==1),:);
    track_in_y = track_y(find(track_flag==1),:);
    % Visualizing the feature tracks on the first and the last frame
    
    points = randi(size(track_in_x,1),20);
    % Part 2.1
    figure(2), imagesc(im{1}), hold off, axis image, colormap gray
    hold on, 
    scatter(track_y(:,1)',track_x(:,1)','g.')
    scatter(track_y(:,2)',track_x(:,end)','r.')
    
    % Part 2.2
    figure(3), imagesc(im{1}), hold off, axis image, colormap gray
    hold on, plot(track_in_y(points,:)', track_in_x(points,:)', 'r');    
    scatter(track_in_y(points,1)',track_in_x(points,1)','g.')
    scatter(track_in_y(points,end)',track_in_x(points,end)','g.')
    
    figure(4), imagesc(im{end}), hold off, axis image, colormap gray
    hold on, plot(track_in_y(points,:)', track_in_x(points,:)', 'r');    
    scatter(track_in_y(points,1)',track_in_x(points,1)','g.')
    scatter(track_in_y(points,end)',track_in_x(points,end)','g.')
    
    
    % Part 2.3
    figure(5), imagesc(im{1}), hold off, axis image, colormap gray
    hold on, 
    % Plot all keypoints
    scatter(track_y(:,1)',track_x(:,1)','g.','linewidth',2)
    % Plot the tracking
    plot(track_y', track_x', 'b');
    % Plot the points going out of the frame
    scatter(track_out_y(:,end)', track_out_x(:,end)', 'r');
    title('Tracked Points going outside the Frame')
function [track_x, track_y, track_flag] = trackPoints(pt_x, pt_y, im, ws, track_flag)
% Tracking initial points (pt_x, pt_y) across the image sequence
% track_x: [Number of keypoints] x [2]
% track_y: [Number of keypoints] x [2]

    % Initialization
    N = numel(pt_x);
    nim = numel(im);
    track_x = zeros(N, nim);
    track_y = zeros(N, nim);
    track_x(:, 1) = pt_x(:);
    track_y(:, 1) = pt_y(:);

    for t = 1:nim-1
        [track_x(:, t+1), track_y(:, t+1), track_flag] = ...
                getNextPoints(track_x(:, t), track_y(:, t), im{t}, im{t+1}, ws, track_flag);
    end


function [x2, y2, track_flag] = getNextPoints(x, y, im1, im2, ws, track_flag)
% Iterative Lucas-Kanade feature tracking
% x,  y : initialized keypoint position in im2
% x2, y2: tracked keypoint positions in im2
% ws: patch window size
    
%% Coarse to FIne Tracnking

%     im1_1 = im1l;
%     im2_1 = im12;
% 
%     im1_2 = impyramid(im1_1, 'reduce');
%     im1_3 = impyramid(im1_2, 'reduce');
%     im2_2 = impyramid(im2_1, 'reduce');
%     im2_3 = impyramid(im2_2, 'reduce');
%     
    % YOUR CODE HERE
    %% Compute Gradient of im1
    [Ix,Iy] = gradient(im1);
    gridLen = floor(ws/2);
    [gridX gridY] = meshgrid(-gridLen:gridLen,-gridLen:gridLen);
    iter = 5;
    x2 = x;
    y2 = y;
    x1 = zeros(1,numel(x));
    y1 = zeros(1,numel(y));
    [maxX maxY] = size(im1);    
    tic
    numel(x)
    for j = 1:numel(x)        
        for i = 1:2       
            if track_flag(j) == 1
                j
                x1 = x(j);
                y1 = y(j);
                if i == 1
                    x2(j) = x1;
                    y2(j) = y1;
                end            

                if (x1 > maxX-gridLen - 1) | (y1 > maxY-gridLen - 1)
                    x2(j) = x1;
                    y2(j) = y1;
                    track_flag(j) = 0;
                    break;
                end

                if (x1 < ws/2) | (y1 < ws/2) 
                    x2(j) = x1;
                    y2(j) = y1;
                    track_flag(j) = 0;
                    break;
                end


                im1GridX = gridX + x1;
                im1GridY = gridY + y1;     

                im2GridX = gridX + x2(j);
                im2GridY = gridY + y2(j);  

                % Getting patches of im1,im2, Ix, Iy
                im1Grid = interp2(im1',im1GridX,im1GridY,'bilinear');
                im2Grid = interp2(im2',im2GridX,im2GridY,'bilinear');
                im1GridIx = interp2(Ix',im1GridX,im1GridY,'bilinear');
                im1GridIy = interp2(Iy',im1GridX,im1GridY,'bilinear');

                imT = im2Grid - im1Grid;      

                B = imT(:)';
                A = [im1GridIx(:),im1GridIy(:)]';



                if rank(A) >= 2
                    d = B/A;
                else
                    d = [y1 x1];
                end

                x2(j) = x2(j) - d(2);
                y2(j) = y2(j) - d(1);    

                if (x2(j) > maxX-gridLen - 1) 
                    x2(j) = x1;
                    track_flag(j) = 0;
                end

                if (y2(j) > maxY-gridLen - 1) 
                    y2(j) = y1; 
                    track_flag(j) = 0;
                end

                if (x2(j) < ws/2)
                    x2(j) = x1;
                    track_flag(j) = 0;
                end

                if (y2(j) < ws/2)
                    y2(j) = y1;
                    track_flag(j) = 0;
                end

                if isnan(x2(j))
                    x2(j) = x1;
                    track_flag(j) = 2;
                end

                if isnan(y2(j))
                    y2(j) = y1;
                    track_flag(j) = 2;
                end
            end
            
        end
    end
    toc

    

function im = readImages(folder, nums)
    im = cell(numel(nums),1);
    t = 0;
    for k = nums,
        t = t+1;
        im{t} = imread(fullfile(folder, ['hotel.seq' num2str(k) '.png']));
        
        im{t} = double(im2single(im{t}));
    end
