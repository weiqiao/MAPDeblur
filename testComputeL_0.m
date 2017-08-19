cl;
PSF=im2double(imread('picassoBlurImage_kernel.png'));
PSF=PSF(:,:,1);
f=PSF/sum(PSF(:));

I=im2double(imread('picassoBlurImage.png'));
L=im2double(imread('picassoSdOut.png'));

[row,col,~]=size(I);

gamma=1e3;
for dimension=1:3
    Lc=L(:,:,dimension);
    psi_x=[diff(Lc, 1, 2), Lc(:,1) - Lc(:,col)];
    psi_y=[diff(Lc, 1, 1); Lc(1,:) - Lc(row,:)];
    LC(:,:,dimension)=computeL(f,I(:,:,dimension),psi_x,psi_y,gamma);
end
delta_L = L - LC;
delta_L=sqrt(sum(sum(delta_L.^2)))
imwrite(L,'computeLtest.png');
