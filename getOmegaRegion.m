function [ omega ] = getOmegaRegion( I, kernelSize )
%GETOMEGAREGION Summary of this function goes here
%   Detailed explanation goes here

[m,n,~]=size(I);
omega=zeros(m,n);
padding=(kernelSize-1)/2;
kernelArea=kernelSize*kernelSize;
gray=rgb2gray(I);
t=5;%threshold
for i = 1+padding:m-padding%row
    for j = 1+padding:n-padding%col
        part=gray(i-padding:i+padding,j-padding:j+padding);
        rows = reshape(part,kernelArea,1);
        if(std(double(rows))<t)
            omega(i,j)=1;
        end
    end
end


%function end
end

