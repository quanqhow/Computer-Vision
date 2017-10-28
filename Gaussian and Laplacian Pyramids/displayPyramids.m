function displayPyramids(G, L)
    N = max(size(G));
    tightSubPlot = tight_subplot(2,N,[.01 .03],[.1 .01],[.01 .01]);
    for i = 1:N
        axes(tightSubPlot(i));
        imshow(G{i});
        title(sprintf('Gaussian of Level %d',i));

        axes(tightSubPlot(i+N));
        imshow(mat2gray(L{i}));
        title(sprintf('Laplacian of Level %d',i));

    %     axes(tightSubPlot(i+(2*N)));
    %     imshow(L{i}+G{i});
    end
end