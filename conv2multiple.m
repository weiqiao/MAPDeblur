function [ A,x,y ] = conv2multiple( L,f,I )
%CONV2MULTIPLE Summary of this function goes here
%   Detailed explanation goes here
[m,n]=size(L);
[~,kernelSize]=size(f);
kernelArea=kernelSize*kernelSize;
%kernelWidth=ceil((kernelSize-1)/2);
x=reshape(f,1,kernelArea);
x=x';
%A=zeros(m*n,kernelArea);
A=zeros((m-kernelSize+1)*(n-kernelSize+1),kernelArea);
I=reshape(I,1,(m-kernelSize+1)*(n-kernelSize+1));
y=I';
%same
% for i=1:m
%     for j=1:n
%         for k=1:kernelSize
%             for h=1:kernelSize
%                 row=i+kernelWidth-h+1;
%                 col=j+kernelWidth-k+1;
%                 if(row<1 || row >m || col<1 || col>n)
%                     A(i+(j-1)*m,h+(k-1)*kernelSize)=0;
%                 else
%                     A(i+(j-1)*m,h+(k-1)*kernelSize)=L(row,col);
%                 end
%             end
%         end
%     end
% end

%valid
for i=1:m-kernelSize+1
    for j=1:n-kernelSize+1
        for k=1:kernelSize
            for h=1:kernelSize
                row=i+kernelSize-1-(h-1);
                col=j+kernelSize-1-(k-1);
                A(i+(j-1)*(m-kernelSize+1),h+(k-1)*kernelSize)=L(row,col);
            end
        end
    end
end



%function end
end