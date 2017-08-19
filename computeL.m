function [ L ] = computeL( f,I,psi_x,psi_y,gamma )
%COMPUTEL Summary of this function goes here
%   Detailed explanation goes here
[m,n]=size(I);
[Nomin1, Denom1, Denom2] = computeDenominator(I, f);
Denom = Denom1 + gamma*Denom2;

%{
Wx = psi_x;
Wy = psi_y;
Wxx = [Wx(:,n) - Wx(:, 1), -diff(Wx,1,2)];
Wxx = Wxx + [Wy(m,:) - Wy(1, :); -diff(Wy,1,1)];
%}

sizey = size(I);
partial_x = psf2otf([1,-1],sizey);
partial_y = psf2otf([1;-1],sizey);

Nomin2 = conj(partial_x) .* fft2(psi_x) + conj(partial_y) .* fft2(psi_y);

Fyout = (Nomin1 + gamma*Nomin2)./Denom;
L = real(ifft2(Fyout));

%funciton end
end

function [Nomin1, Denom1, Denom2] = computeDenominator(y, k)
    sizey = size(y);

    partial_x = psf2otf([1,-1],sizey);
    partial_y = psf2otf([1;-1],sizey);
    
    partial_xx = psf2otf([1,-2,1],sizey);
    partial_yy = psf2otf([1;-2;1],sizey);

    para=50 + 25 * (partial_x .* conj(partial_x) + partial_y .* conj(partial_y)) + 25 / 2 * (partial_xx .* conj(partial_xx) + partial_yy .* conj(partial_yy));
    %para=50;
    otfk  = psf2otf(k, sizey);
    Nomin1 = conj(otfk) .* fft2(y) .* para;
    Denom1 = conj(otfk) .* otfk .* para;
    Denom2 = partial_x .* conj(partial_x) + partial_y .* conj(partial_y);
end