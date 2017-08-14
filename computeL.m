function [ L ] = computeL( f,I,psi_x,psi_y,gamma )
%COMPUTEL Summary of this function goes here
%   Detailed explanation goes here
[m,n]=size(I);
[Nomin1, Denom1, Denom2] = computeDenominator(I, f);
Denom = Denom1 + gamma*Denom2;
Wx = psi_x;
Wy = psi_y;
Wxx = [Wx(:,n) - Wx(:, 1), -diff(Wx,1,2)];
Wxx = Wxx + [Wy(m,:) - Wy(1, :); -diff(Wy,1,1)];

Fyout = (Nomin1 + gamma*fft2(Wxx))./Denom;
L = real(ifft2(Fyout));

%funciton end
end

function [Nomin1, Denom1, Denom2] = computeDenominator(y, k)
    % para=50+25*conj(f_diff_x).*f_diff_x+25*conj(f_diff_y).*f_diff_y;
    para=50;
    sizey = size(y);
    otfk  = psf2otf(k, sizey);
    Nomin1 = conj(otfk).*fft2(y)*para;
    Denom1 = abs(otfk).^2*para;
    Denom2 = abs(psf2otf([1,-1],sizey)).^2 + abs(psf2otf([1;-1],sizey)).^2;
end