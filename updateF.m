function [ f ] = updateF( L,f,I )
%UPDATEF Summary of this function goes here
%   Detailed explanation goes here
lambda=1;
[kernelSize,~]=size(f);
kernelWidth=ceil((kernelSize-1)/2);
rel_tol=0.02;

diff_x=[1,-1];
diff_y=[1,-1]';
L_fast=L(130:230,340:440);
I_fast=I(130+kernelWidth:230-kernelWidth,340+kernelWidth:440-kernelWidth);
L_x=conv2(L,diff_x,'same');
L_x_fast=L_x(130:230,340:440);
L_y=conv2(L,diff_y,'same');
L_y_fast=L_y(130:230,340:440);
I_x=conv2(I,diff_x,'same');
I_x_fast=I_x(130+kernelWidth:230-kernelWidth,340+kernelWidth:440-kernelWidth);
I_y=conv2(I,diff_y,'same');
I_y_fast=I_y(130+kernelWidth:230-kernelWidth,340+kernelWidth:440-kernelWidth);

% [A,~,y]=conv2multiple(L_fast,f,I_fast);
% A=50*A;
[A1,~,y1]=conv2multiple(L_fast,f,I_fast);
[A2,~,y2]=conv2multiple(L_x_fast,f,I_x_fast);
[A3,~,y3]=conv2multiple(L_y_fast,f,I_y_fast);
A=cat(1,sqrt(50)*A1,5*A2,5*A3);
y=cat(1,sqrt(50)*y1,5*y2,5*y3);
[x,status]=l1_ls(A,y,lambda,rel_tol);
threshold=max(max(f))*.01;
kernelArea=kernelSize*kernelSize;
for i=1:kernelArea
    if(x(i) < threshold)
        x(i)=0;
    end
end
f=reshape(x,[kernelSize kernelSize]);
f=f/sum(f(:));

%function end
end

