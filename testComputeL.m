kernelSize=27;
PSF=im2double(imread('picassoBlurImage_kernel.png'));
PSF=PSF(:,:,1);
f=PSF/sum(PSF(:));
% f=eye(kernelSize,kernelSize)/(kernelSize);
I=im2double(imread('picassoBlurImage.png'));
L=im2double(imread('picassoSdOut.png'));

if ~exist('omega','var')
    omega=getOmegaRegion(I,kernelSize);
end

[row,col,~]=size(I);

LC=I;
repeat=0;
lambda1=0.008/(1.2^repeat);
lambda2=0.2/(1.5^repeat);
gamma=1*2^repeat;
iterator=0;
while(iterator<5)
    iterator = iterator+1;
    for dimension=1:3
    %     Lc=L(:,:,dimension);
    %     psi_x=[diff(Lc, 1, 2), Lc(:,1) - Lc(:,col)];
    %     psi_y=[diff(Lc, 1, 1); Lc(1,:) - Lc(row,:)];
        [psi_x,psi_y]=updatePSI(lambda1,lambda2,omega,gamma,LC(:,:,dimension),I(:,:,dimension));
        LC(:,:,dimension)=computeL(f,I(:,:,dimension),psi_x,psi_y,gamma);
    end
%     lambda1=lambda1/1.2;
%     lambda2=lambda2/1.5;
%     gamma=gamma*2;
    imwrite(LC,['out_',int2str(iterator),'computeLtest.png']);
end