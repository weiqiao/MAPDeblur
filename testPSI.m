cl;
PSF=im2double(imread('picassoBlurImage_kernel.png'));
PSF=PSF(:,:,1);
f=PSF/sum(PSF(:));

I=im2double(imread('picassoBlurImage.png'));
L=im2double(imread('picassoSdOut.png'));

diff_x=[1,-1];
diff_y=[1,-1]';
p_LC=L;
psi_x=L;
psi_y=L;
for dimension=1:3
    psi_x(:,:,dimension)=conv2(L(:,:,dimension),diff_x,'same');
    psi_y(:,:,dimension)=conv2(L(:,:,dimension),diff_y,'same');
end

lambda1=0.008;
lambda2=10;
gamma=1e10;
tol = 1e-5;
p_delta_L=inf;
if ~exist('omega','var')
    omega=getOmegaRegion(I,27);
    %imwrite(omega,['omega.png']);
end
%I = im2double(I);
LC = I;
disp('start iteration');
iterator=1;
[row,col,~]=size(I);

while(iterator < 2)
    for dimension=1:3
        [psi_x_c,psi_y_c]=updatePSI(lambda1,lambda2,omega,gamma,L(:,:,dimension),L(:,:,dimension));
        %compute L
        Lc=L(:,:,dimension);
        psi_x=[diff(Lc, 1, 2), Lc(:,1) - Lc(:,col)];
        psi_y=[diff(Lc, 1, 1); Lc(1,:) - Lc(row,:)];
        max(max(psi_x_c-psi_x))
        sum(sum(abs(psi_x_c-psi_x)))
        LC(:,:,dimension)=computeL(f,I(:,:,dimension),psi_x_c,psi_y_c,gamma);
        LC = im2double(LC);
    end
    delta_L=LC-p_LC;
    delta_L=sqrt(sum(sum(delta_L.^2)));
    fprintf('iterator:%d,(%f,%f,%f)\n',iterator,delta_L(:,:,1),delta_L(:,:,2),delta_L(:,:,3));
    if(delta_L(:,:,1)<tol && delta_L(:,:,2)<tol && delta_L(:,:,3)<tol)
        LC=p_LC;
        break;
    end
    p_LC=LC;
    p_delta_L=sum(delta_L);
    imwrite(LC,['out_',int2str(iterator),'picassoBlurImage.png']);
    iterator=iterator+1;
end
