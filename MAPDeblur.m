function [ L, f ] = MAPDeblur( filePath, kernelSize)
%MAPDEBLUR Summary of this function goes here
%   调用方式：MAPDeblur('picassoBlurImage.png',27);
I=imread(filePath);%3d
omega=getOmegaRegion(I,kernelSize);
I=double(I)/255;%scale to [0,1]

L=I;
p_L=L;
f=eye(kernelSize,kernelSize)/(kernelSize*kernelSize);
p_f=f;
[m,n,~]=size(I);
p_psi_x=zeros(m,n);
p_psi_y=zeros(m,n);
iterator=1;
disp('start iteration');
%para init
lambda1=0.002;
lambda2=20;
gamma=1;
while 1
    %update L and f
    for dimension=1:3
        while 1
            %update L
            [psi_x,psi_y]=updatePSI(lambda1,lambda2,omega,gamma,L(:,:,dimension),I(:,:,dimension));
            %compute L
            L(:,:,dimension)=computeL(f,I(:,:,dimension),psi_x,psi_y,gamma);
            delta_L=L(:,:,dimension)-p_L(:,:,dimension);
            delta_L=norm(delta_L,2);
            delta_psi_x=psi_x-p_psi_x;
            delta_psi_x=norm(delta_psi_x,2);
            delta_psi_y=psi_y-p_psi_y;
            delta_psi_y=norm(delta_psi_y,2);
            if(delta_L<10^-5 && delta_psi_x<10^-5 && delta_psi_y<10^-5)
                break;%跳出循环
            end
            p_L=L;
            p_psi_x=psi_x;
            p_psi_y=psi_y;
            fprintf('update L:%f\n',delta_L);
        end
    end
    imwrite(L,['out_',int2str(iterator),filePath]);
    %update f
    grayL=rgb2gray(L);
    grayI=rgb2gray(I);
    f=updateF(grayL,f,grayI);
    delta_f=f-p_f;
    delta_f=norm(delta_f,2);
    if(delta_f<10^-5)
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

