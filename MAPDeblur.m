function [ L, f ] = MAPDeblur( filePath, kernelSize)
%MAPDEBLUR Summary of this function goes here
%   call MAPDeblur('picassoBlurImage.png',27);
I=im2double(imread(filePath));%3d
%I=I(110:210,470:670,:);
omega=getOmegaRegion(I,kernelSize);
I=rgb2gray(I);

PSF=im2double(imread('picassoBlurImage_kernel.png'));
PSF=PSF(:,:,1);
%f=PSF/sum(PSF(:));
f=eye(kernelSize,kernelSize)/(kernelSize);
p_f=f;
[m,n,~]=size(I);
p_psi_x=zeros(m,n);
p_psi_y=zeros(m,n);
iterator=1;
lambda1=0.008;
lambda2=10;%0.2;

tol = 1e-5;
tol_f = 1e-2;
%para init
L=I;
p_L=L;
double_gamma_itr = 1;
disp('start iteration');
for nnn=1:1,
    %update L and f
    %p_delta_L=inf;
    inner_itr = 0;
    gamma=1;
    while 1
        
        inner_itr = inner_itr + 1;
        for dim = 1:1,
            %update L
            [psi_x,psi_y]=updatePSI(lambda1,lambda2,omega,gamma,L(:,:,dim),I(:,:,dim));
            %compute L
            L(:,:,dim)=computeL(f,I(:,:,dim),psi_x,psi_y,gamma);
        end;
        delta_L=L-p_L;
        delta_L=sqrt(sum(sum(delta_L.^2)));
        delta_psi_x=psi_x-p_psi_x;
        delta_psi_x=sqrt(sum(sum(delta_psi_x.^2)));
        delta_psi_y=psi_y-p_psi_y;
        delta_psi_y=sqrt(sum(sum(delta_psi_y.^2)));
        if(max(delta_L)<tol || delta_psi_x<tol || delta_psi_y<tol)
            break;
        end
        %{
        if(delta_L>p_delta_L)
            % does not converge
            fprintf('does not converge gamma:%d\n',gamma);
            lambda1=lambda1/1.2;
            lambda2=lambda2/1.5;
            gamma=gamma*2;
            %reset
            L=I;
            p_L=L;
            p_delta_L=inf;
            fprintf('reset para:%d\n',gamma);
            continue;
        end
        %}
        p_L=L;
        %p_delta_L=delta_L;
        p_psi_x=psi_x;
        p_psi_y=psi_y;
        if inner_itr > double_gamma_itr, gamma = gamma*2; end;
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
    if(delta_f<tol_f)
        break;
    end
    lambda1=lambda1/1.2;
    lambda2=lambda2/1.5;
    rate=1/max(max(f));
    imwrite(f*rate,['kernel_',int2str(iterator),filePath]);
    iterator=iterator+1;
    fprintf('gamma:%d,delta_f:%f\n',gamma,delta_f);
    p_f = f;
end



%function end
end

