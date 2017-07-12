PSF=im2double(imread('picassoBlurImage_kernel.png'));
PSF=PSF(:,:,1);
f=PSF/sum(PSF(:));

I=im2double(imread('picassoBlurImage.png'));
L=im2double(imread('picassoSdOut.png'));

diff_x=[1,-1];
diff_y=[1,-1]';

gamma=1;
for dimension=1:3
    psi_x=conv2(L(:,:,dimension),diff_x,'same');
    psi_y=conv2(L(:,:,dimension),diff_y,'same');
    L(:,:,dimension)=computeL(f,I(:,:,dimension),psi_x,psi_y,gamma);
end

imwrite(L,'computeLtest.png');