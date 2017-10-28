function displayFFTs(G, L)
    N = max(size(G));
    tightSubPlot = tight_subplot(2,N,[.01 .03],[.1 .01],[.01 .01]);
    for i = 1:N
        axes(tightSubPlot(i));
        imagesc(log(abs(fftshift(fft2(G{i}))))) ;

        axes(tightSubPlot(i+N));
        imagesc(log(abs(fftshift(fft2(mat2gray(L{i})))))) ;

    %     axes(tightSubPlot(i+(2*N)));
    %     imshow(L{i}+G{i});
    end
end