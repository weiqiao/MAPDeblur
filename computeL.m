function [ L ] = computeL( f,I,psi_x,psi_y,gamma )
%COMPUTEL Summary of this function goes here
%   Detailed explanation goes here
[m,n]=size(I);
f_f=fft2(f,m,n);
diff_x=[1,-1];
f_diff_x=fft2(diff_x,m,n);
diff_y=[1,-1]';
f_diff_y=fft2(diff_y,m,n);
para=50+25*conj(f_diff_x).*f_diff_x+25*conj(f_diff_y).*f_diff_y;
fenzi=conj(f_f).*fft2(I).*para+gamma*conj(f_diff_x).*fft2(psi_x)+gamma*conj(f_diff_y).*fft2(psi_y);
fenmu=conj(f_f).*f_f.*para+gamma*conj(f_diff_x).*f_diff_x+gamma*conj(f_diff_y).*f_diff_y;
L=ifft2(fenzi./fenmu);
L=real(L);%abs(L)? ≤ª ’¡≤


%funciton end
end

