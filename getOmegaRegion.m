function [ omega ] = getOmegaRegion( I, kernelSize)
%GETOMEGAREGION Summary of this function goes here
%   Detailed explanation goes here

[m,n,~]=size(I);
omega=zeros(m,n);
padding=floor(kernelSize/2);
kernelArea=kernelSize*kernelSize;
gray=rgb2gray(I);
t = 5/255;
gray = padarray(gray, [1 1] * padding, 'replicate', 'both');
[row,col]=size(gray);
rowStart=1+padding;
rowEnd=row-padding;
colStart=1+padding;
colEnd=col-padding;
for i = rowStart:rowEnd
    for j = colStart:colEnd
        part=gray(i-padding:i+padding,j-padding:j+padding);
        rows = reshape(part,kernelArea,1);
        if(std(double(rows))<t)
            omega(i-padding,j-padding)=1;
        end
    end
end
%function end
end

