function [ A,x,y ] = conv2multiple_topN( L,f,I )
%CONV2MULTIPLE Summary of this function goes here
%   Detailed explanation goes here
[m,n]=size(L);
[~,kernelSize]=size(f);
kernelArea=kernelSize*kernelSize;
padding=(kernelSize-1)/2;
%kernelWidth=ceil((kernelSize-1)/2);
x=reshape(f,1,kernelArea);
x=x';
startX=round(m*.2);
endX=round(m*.8);
startY=round(n*.2);
endY=round(n*.8);
stdRect=zeros(m,n);
maxPercent=round(m*n*.64*.1);% top 10%
A=zeros(maxPercent,kernelArea);
y=zeros(maxPercent,1);
for i=startX:endX
    for j=startY:endY
        part=L(i-padding:i+padding,j-padding:j+padding);
        rows = reshape(part,kernelArea,1);
        stdRect(i,j)=std(rows);
    end
end
stdRows=reshape(stdRect,1,m*n);
stdRows=sort(stdRows,'descend');
threshold=stdRows(maxPercent);
indexA=1;
%disp(maxPercent);
for i=startX:endX
    for j=startY:endY
        if(stdRect(i,j)>=threshold)
            if(indexA>maxPercent)
                return;
            end
            y(indexA)=I(i,j);
            for k=1:kernelArea
                krow=mod(k-1,kernelSize)+1;
                kcol=floor((k-1)/kernelSize);
                A(indexA,k)=L(i+padding-krow,j+padding-kcol);
            end
            indexA=indexA+1;
        end
    end
end



%function end
end