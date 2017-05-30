function [ L ] = computeL( f,I,psi_x,psi_y,gamma )
%COMPUTEL Summary of this function goes here
%   Detailed explanation goes here
[m,n]=size(I);
f(m,n)=0;
f_f=fft2(f);
fenzi=conj(f_f).*fft2(I)*50+gamma*(-1i)*fft2(psi_x)+gamma*(-1i)*fft2(psi_y);
fenmu=conj(f_f).*f_f*50+2*gamma;
L=ifft2(fenzi./fenmu);
L=real(L);%or abs(L) 但会不收敛


%funciton end
end

