L=im2double(imread('picassoSdOut.png'));
% PSF=im2double(imread('picassoBlurImage_kernel.png'));
% PSF=PSF(:,:,1);
% f=PSF/sum(PSF(:));
kernelSize=27;
f=eye(kernelSize,kernelSize)/(kernelSize);
I=im2double(imread('picassoBlurImage.png'));

L=rgb2gray(L);
I=rgb2gray(I);

f=updateF_topN( L,f,I );

imwrite(f/max(f(:)),'kernel_test.png');