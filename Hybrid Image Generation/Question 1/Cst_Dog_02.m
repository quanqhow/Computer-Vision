% Debugging tip: You can split your MATLAB code into cells using "%%"
% comments. The cell containing the cursor has a light yellow background,
% and you can press Ctrl+Enter to run just the code in that cell. This is
% useful when projects get more complex and slow to rerun from scratch

close all; % closes all figures

%% Setup
% read images and convert to floating point format
image1 = im2single(imread('data/dog.bmp'));
image2 = im2single(imread('data/cat.bmp'));

grayImage1 = rgb2gray(image1);
grayImage2 = rgb2gray(image2);

% Several additional test cases are provided for you, but feel free to make
% your own (you'll need to align the images in a photo editor such as
% Photoshop). The hybrid images will differ depending on which image you
% assign as image1 (which will provide the low frequencies) and which image
% you asign as image2 (which will provide the high frequencies)

%% Log Magnitude Spectrums of the original images;

colormap(gray)
logSpecMagImage1 = log(abs(fftshift(fft2(grayImage1))));
logSpecMagImage2 = log(abs(fftshift(fft2(grayImage2))));

figure(1);
subplot(2,2,3);
imshow(logSpecMagImage1)
title('Log Magnitude of Fourier Transform of Image 1')
subplot(2,2,4);
imshow(logSpecMagImage2);
title('Log Magnitude of Fourier Transform of Image 2')
subplot(2,2,1);
imshow(grayImage1);
title('Image 1')
subplot(2,2,2);
imshow(grayImage2);
title('Image 2')

%% Filtering and Hybrid Image construction
cutoff_frequency1 = 10;
cutoff_frequency2 = 10;
tune1 = 5
tune2 = 2
%This is the standard deviation, in pixels, of the 
% Gaussian blur that will remove the high frequencies from one image and 
% remove the low frequencies from another image (by subtracting a blurred
% version from the original version). You will want to tune this for every
% image pair to get the best results.
filter1 = fspecial('Gaussian', cutoff_frequency1*tune1+1, cutoff_frequency1);
logSpecMagFilter1 = log(abs(fftshift(fft2(filter1))));
filter2 = fspecial('Gaussian', cutoff_frequency2*tune2+1, cutoff_frequency2);
logSpecMagFilter2 = log(abs(fftshift(fft2(filter2))));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE BELOW. Use imfilter() to create 'low_frequencies' and
% 'high_frequencies' and then combine them to create 'hybrid_image'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove the high frequencies from image1 by blurring it. The amount of
% blur that works best will vary with different image pairs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lowFrequencies = imfilter(grayImage1,filter1);
logSpecMaglowFrequencies = log(abs(fftshift(fft2(lowFrequencies))));

figure(2)
subplot(2,3,1);
imshow(grayImage1);
title('Image 1')
subplot(2,3,2);
surf(filter1);
title('Low Pass Filter')
subplot(2,3,3);
imshow(lowFrequencies);
title('Low Pass Filtered Image 1')
subplot(2,3,4);
imshow(logSpecMagImage1)
title('Log Magnitude of Fourier Transform of Image 1')
subplot(2,3,5);
imshow(logSpecMagFilter1)
title('Log Magnitude of Fourier Transform of the Filter')
subplot(2,3,6);
imshow(logSpecMaglowFrequencies)
title('Log Magnitude of Fourier Transform of the Filtered Image')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove the low frequencies from image2. The easiest way to do this is to
% subtract a blurred version of image2 from the original version of image2.
% This will give you an image centered at zero with negative values.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

highFrequencies = grayImage2 - imfilter(grayImage2,filter);
logSpecMagHighFrequencies = log(abs(fftshift(fft2(highFrequencies))));

figure(3)
subplot(2,3,1);
imshow(grayImage2);
title('Image 2')
subplot(2,3,2);
surf(1 - filter2);
title('High Pass Filter')
subplot(2,3,3);
imshow(highFrequencies+0.2);
title('High Pass Filtered Image 1')
subplot(2,3,4);
imshow(logSpecMagImage2)
title('Log Magnitude of Fourier Transform of Image 2')
subplot(2,3,5);
imshow(logSpecMagFilter2)
title('Log Magnitude of Fourier Transform of the Filter')
subplot(2,3,6);
imshow(logSpecMagHighFrequencies)
title('Log Magnitude of Fourier Transform of the Filtered Image')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Combine the high frequencies and low frequencies
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hybridImage = lowFrequencies + highFrequencies;
logSpecMagHybridImage = log(abs(fftshift(fft2(hybridImage))));

figure(4)
subplot(2,3,1);
imshow(lowFrequencies);
title('Image 1')
subplot(2,3,2);
imshow(highFrequencies+0.5);
title('Image 2');
subplot(2,3,3);
imshow(hybridImage);
title('Hybrid Image');
subplot(2,3,4);
imshow(logSpecMagImage1)
title('Log Magnitude of Fourier Transform of Image 1')
subplot(2,3,5);
imshow(logSpecMagImage2)
title('Log Magnitude of Fourier Transform of Image 2')
subplot(2,3,6);
imshow(logSpecMagHybridImage)
title('Log Magnitude of Fourier Transform of the Hybrid Image')

vis = vis_hybrid_image(hybridImage);
figure(5); 
imshow(vis);
