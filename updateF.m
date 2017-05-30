function [ f ] = updateF( L,f,I )
%UPDATEF Summary of this function goes here
%   Detailed explanation goes here
lambda=1;
rel_tol=0.1/27/27;
[kernelSize,~]=size(f);
L_fast=L(130:230,340:440);
I_fast=I(130:230,340:440);
[A,~,y]=conv2multiple(L_fast,f,I_fast);
[x,status]=l1_ls(A,y,lambda,rel_tol);
f=reshape(x,[kernelSize kernelSize]);
f=f/sum(f(:));

%function end
end

