cl;
I=imread('picassoBlurImage.png');
kernelSize=27;
omega=getOmegaRegion(I,kernelSize);
imwrite(omega,'omega.png');
