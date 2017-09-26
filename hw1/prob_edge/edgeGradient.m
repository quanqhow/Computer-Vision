function bmap = edgeGradient(im);
    sigma = 3;
    [mag, theta] = gradientMagnitude(im, sigma);
    
    %improved the magnitude for better resolution.
    mag = mag .^ 0.7;
    %changed the oreintation according to the nonmax function
    theta = theta + pi/2;
    bmap = nonmax(mag,theta);
end