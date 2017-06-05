function [ L ] = computeL( f,I,psi_x,psi_y,gamma )
%COMPUTEL Summary of this function goes here
%   Detailed explanation goes here
[m,n]=size(I);
f(m,n)=0;
f_f=fft2(f);
diff_x=[1,-1];
diff_y=[1,-1]';
fenzi=conj(f_f).*fft2(I)*50+gamma*fftshift(fft2(conv2(psi_x,diff_x,'same')))+gamma*fftshift(fft2(conv2(psi_y,diff_y,'same')));
fenmu=conj(f_f).*f_f*50+2*gamma;
L=ifft2(fenzi./fenmu);
L=real(L);%abs(L)? ≤ª ’¡≤


%funciton end
end

