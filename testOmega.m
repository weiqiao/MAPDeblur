cl;
I=im2double(imread('picassoBlurImage.png'));
kernelSize=27;
t=15e-3;%threshold
omega=getOmegaRegion(I,kernelSize,t);
imwrite(omega,'omega.png');
