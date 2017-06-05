function [ f ] = updateF( L,f,I )
%UPDATEF Summary of this function goes here
%   Detailed explanation goes here
lambda=1;
[kernelSize,~]=size(f);
rel_tol=0.1/kernelSize/kernelSize;
%L_fast=L(130:230,340:440);
%I_fast=I(130:230,340:440);
diff_x=[1,-1];
diff_y=[1,-1]';
[A1,~,y1]=conv2multiple(L,f,I);
[A2,~,y2]=conv2multiple(conv2(L,diff_x,'same'),f,conv2(I,diff_x,'same'));
[A3,~,y3]=conv2multiple(conv2(L,diff_y,'same'),f,conv2(I,diff_y,'same'));
A=cat(1,A1,A2,A3);
y=cat(1,y1,y2,y3);
[x,status]=l1_ls_nonneg(A,y,lambda,rel_tol);
f=reshape(x,[kernelSize kernelSize]);
f=f/sum(f(:));

%function end
end

