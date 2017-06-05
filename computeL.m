function [ L ] = computeL( f,I,psi_x,psi_y,gamma )
%COMPUTEL Summary of this function goes here
%   Detailed explanation goes here
[m,n]=size(I);
f(m,n)=0;
f_f=fft2(f);
diff_x=[1,-1];
f_diff_x=fft2(diff_x,m,n);
diff_y=[1,-1]';
f_diff_y=fft2(diff_y,m,n);
fenzi=conj(f_f).*fft2(I)*50+gamma*conj(fft2(conv2(psi_x,diff_x,'same')))+gamma*conj(fft2(conv2(psi_y,diff_y,'same')));
fenmu=conj(f_f).*f_f*50+gamma*conj(f_diff_x).*f_diff_x+gamma*conj(f_diff_y).*f_diff_y;
L=ifft2(fenzi./fenmu);
L=real(L);%abs(L)? ≤ª ’¡≤


%funciton end
end

