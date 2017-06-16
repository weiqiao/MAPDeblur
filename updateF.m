function [ f ] = updateF( L,f,I )
%UPDATEF Summary of this function goes here
%   Detailed explanation goes here
lambda=1;
[kernelSize,~]=size(f);
kernelWidth=ceil((kernelSize-1)/2);
rel_tol=0.02;
L_fast=L(130:230,340:440);
I_fast=I(130+kernelWidth:230-kernelWidth,340+kernelWidth:440-kernelWidth);
[A,~,y]=conv2multiple(L_fast,f,I_fast);

%diff_x=[1,-1];
%diff_y=[1,-1]';
%[A1,~,y1]=conv2multiple(L_fast,f,I_fast);
%[A2,~,y2]=conv2multiple(conv2(L_fast,diff_x,'same'),f,conv2(I_fast,diff_x,'same'));
%[A3,~,y3]=conv2multiple(conv2(L_fast,diff_y,'same'),f,conv2(I_fast,diff_y,'same'));
%A=cat(1,A1,A2,A3);
%y=cat(1,y1,y2,y3);
[x,status]=l1_ls(A,y,lambda,rel_tol);
for i=1:kernelSize*kernelSize
    if(x(i) < 0.0001)
        x(i)=0;
    end
end
f=reshape(x,[kernelSize kernelSize]);
f=f/sum(f(:));

%function end
end

