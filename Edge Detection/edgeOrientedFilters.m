function bmap = edgeOrientedFilters(im);    
    [mag, theta] = orientedFilterMagnitude(im);
    
    %improved the magnitude for better resolution.
    mag = mag .^ 0.7;
    %changed the oreintation according to the nonmax function
    theta = theta + pi/2;
    bmap = nonmax(mag,theta);
end