function [ L, f ] = MAPDeblur( filePath, kernelSize)
%MAPDEBLUR Summary of this function goes here
%   调用方式：MAPDeblur('picassoBlurImage.png',27);
I=im2double(imread(filePath));%3d
%I=I(110:210,470:670,:);
omega=getOmegaRegion(I,kernelSize);
I=rgb2gray(I);

PSF=im2double(imread('picassoBlurImage_kernel.png'));
PSF=PSF(:,:,1);
f=PSF/sum(PSF(:));
% f=eye(kernelSize,kernelSize)/(kernelSize);
p_f=f;
[m,n,~]=size(I);
p_psi_x=zeros(m,n);
p_psi_y=zeros(m,n);
iterator=1;
lambda1=0.008;
lambda2=0.2;
gamma=1;
%para init
L=I;
p_L=L;
disp('start iteration');
while 1
    %update L and f
    p_delta_L=inf;
    while 1
        %update L
        [psi_x,psi_y]=updatePSI(lambda1,lambda2,omega,gamma,L,I);
        %compute L
        L=computeL(f,I,psi_x,psi_y,gamma);
        delta_L=L-p_L;
        delta_L=sqrt(sum(sum(delta_L.^2)));
        delta_psi_x=psi_x-p_psi_x;
        delta_psi_x=sqrt(sum(sum(delta_psi_x.^2)));
        delta_psi_y=psi_y-p_psi_y;
        delta_psi_y=sqrt(sum(sum(delta_psi_y.^2)));
        if(delta_L<10 || delta_psi_x<10 || delta_psi_y<10)
            break;%跳出循环
        end
        if(delta_L>p_delta_L)
            %不收敛
            fprintf('不收敛 gamma:%d\n',gamma);
            lambda1=lambda1/1.2;
            lambda2=lambda2/1.5;
            gamma=gamma*2;
            %重置
            L=I;
            p_L=L;
            p_delta_L=inf;
            fprintf('reset para:%d\n',gamma);
            continue;
        end
        p_L=L;
        p_delta_L=delta_L;
        p_psi_x=psi_x;
        p_psi_y=psi_y;
        fprintf('update L:%f\n',delta_L);
    end
    imwrite(L,['out_',int2str(iterator),filePath]);
    %update f
    %grayL=rgb2gray(L);
    %grayI=rgb2gray(I);
    %f=updateF(grayL,f,grayI);
    f=updateF(L,f,I);
    delta_f=f-p_f;
    delta_f=sqrt(sum(sum(delta_f.^2)));
    if(delta_f<10^-2)
        break;%跳出循环
    end
    lambda1=lambda1/1.2;
    lambda2=lambda2/1.5;
    gamma=gamma*2;
    rate=1/max(max(f));
    imwrite(f*rate,['kernel_',int2str(iterator),filePath]);
    iterator=iterator+1;
    fprintf('gamma:%d,delta_f:%f\n',gamma,delta_f);
end



%function end
end

