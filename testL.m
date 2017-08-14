I=imread('picassoBlurImage.png');%3d
if ~exist('omega','var')
    omega=getOmegaRegion(I,27);
end
I=im2double(I);
%imwrite(omega,'omega.png');
PSF=im2double(imread('picassoBlurImage_kernel.png'));
PSF=PSF(:,:,1);
f=PSF/sum(PSF(:));
%f=eye(kernelSize,kernelSize)/(kernelSize);
[m,n,~]=size(I);
disp('start iteration');
%para init
% repeat=6;
% lambda1=0.008/(1.2^repeat);
% lambda2=0.2/(1.5^repeat);
% gamma=1*2^repeat;
lambda1=0.008;
lambda2=0.2;
gamma=1;
% L=im2double(imread('picassoSdOut.png'));
L=I;
[row,col,~]=size(I);
iterator=0;
while(iterator<5)
    iterator=iterator+1;
    for dimension=1:3
        %update psi
        [psi_x,psi_y]=updatePSI(lambda1,lambda2,omega,gamma,L(:,:,dimension),I(:,:,dimension));
        %compute L
        L(:,:,dimension)=computeL(f,I(:,:,dimension),psi_x,psi_y,gamma);
    end
    imwrite(L,['out_',int2str(iterator),'_picassoBlurImage.png']);
    lambda1=lambda1/1.2;
    lambda2=lambda2/1.5;
    gamma=gamma*2;
end


