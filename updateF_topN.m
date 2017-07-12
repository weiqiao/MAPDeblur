function [ f ] = updateF_topN( L,f,I )
%UPDATEF Summary of this function goes here
%   Detailed explanation goes here
lambda=1;
[kernelSize,~]=size(f);
rel_tol=0.02;

diff_x=[1,-1];
diff_y=[1,-1]';
L_x=conv2(L,diff_x,'same');
L_y=conv2(L,diff_y,'same');
I_x=conv2(I,diff_x,'same');
I_y=conv2(I,diff_y,'same');

% [A1,~,y1]=conv2multiple_topN(L,f,I);
% [A2,~,y2]=conv2multiple_topN(L_x,f,I_x);
% [A3,~,y3]=conv2multiple_topN(L_y,f,I_y);
% A=cat(1,sqrt(50)*A1,5*A2,5*A3);
% y=cat(1,sqrt(50)*y1,5*y2,5*y3);
[A,~,y]=conv2multiple_topN(L,f,I);
[x,~]=l1_ls(A,y,lambda,rel_tol);
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

