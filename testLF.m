% PSF=im2double(imread('picassoBlurImage_kernel.png'));
% PSF=PSF(:,:,1);
% f=PSF/sum(PSF(:));
kernelSize=27;
f=eye(kernelSize,kernelSize)/(kernelSize);
I=im2double(imread('picassoBlurImage.png'));
L=im2double(imread('picassoSdOut.png'));

diff_x=[1,-1];
diff_y=[1,-1]';
% LC=L;
LC=I;
p_LC=LC;

if ~exist('omega','var')
    omega=getOmegaRegion(I,27);
end
disp('start iteration');
level=0;
while(1)
    iterator=0;
    p_delta_L=inf;
    lambda1=0.008;
    lambda2=0.2;
    gamma=1;
%     LC=I;
%     p_LC=LC;
    while(iterator<5)
        for dimension=1:3
            [psi_x_c,psi_y_c]=updatePSI(lambda1,lambda2,omega,gamma,LC(:,:,dimension),I(:,:,dimension));
            %compute L
            LC(:,:,dimension)=computeL(f,I(:,:,dimension),psi_x_c,psi_y_c,gamma);
        end
        delta_L=LC-p_LC;
        delta_L=sqrt(sum(sum(delta_L.^2)));
        fprintf('iterator:%d,(%f,%f,%f)\n',iterator,delta_L(:,:,1),delta_L(:,:,2),delta_L(:,:,3));
        if(delta_L(:,:,1)<10 && delta_L(:,:,2)<10 && delta_L(:,:,3)<10)
            break;
        end
        if(sum(delta_L) > p_delta_L)
            LC=p_LC;
            fprintf('≤ª ’¡≤ gamma:%d\n',gamma);
            break;
        end
        p_LC=LC;
        p_delta_L=sum(delta_L);
        iterator=iterator+1;
        lambda1=lambda1/1.2;
        lambda2=lambda2/1.5;
        gamma=gamma*2;
    end
    imwrite(LC,['out_',int2str(level),'picassoBlurImage.png']);
    L=rgb2gray(LC);
    grayI=rgb2gray(I);

    f=updateF_topN( L,f,grayI );

    maxF=max(f(:));
    imwrite(f./maxF,['kernel_',int2str(level),'_test.png']);
    level=level+1;
end