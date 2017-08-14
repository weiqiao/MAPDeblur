function [ psi_x,psi_y ] = updatePSI( lambda1,lambda2,omega,gamma,L,I )
%UPDATEPSI Summary of this function goes here
%   Detailed explanation goes here

[row,col]=size(I);
pI_x=[diff(I, 1, 2), I(:,1) - I(:,col)];
pI_y=[diff(I, 1, 1); I(1,:) - I(row,:)];
pL_x=[diff(L, 1, 2), L(:,1) - L(:,col)];
pL_y=[diff(L, 1, 1); L(1,:) - L(row,:)];
a=6.1*(10^-4);
b=5.0;
k=2.7;
lt=(k-sqrt(k^2-4*a*b))/(2*a);

psi_x=zeros(row,col);
psi_y=zeros(row,col);

result=zeros(1,3);
x=result;
for i=1:row
    for j=1:col
        %for abs(x)>=lt
        temp=(pI_x(i,j)*lambda2*omega(i,j)+gamma*pL_x(i,j))/(lambda2*omega(i,j)+gamma+lambda1*a);
        if(abs(temp)>lt)
            x(1)=temp;
        elseif(temp>0)
            x(1)=lt;
        else
            x(1)=-lt;
        end
        result(1)=(a*lambda1+lambda2*omega(i,j)+gamma)*x(1)^2-2*(lambda2*pI_x(i,j)*omega(i,j)+gamma*pL_x(i,j))*x(1)+(b*lambda1+lambda2*omega(i,j)*pI_x(i,j)^2+gamma*pL_x(i,j)^2);
        
        %for 0<=x<=lt
        temp=(2*lambda2*omega(i,j)*pI_x(i,j)+2*gamma*pL_x(i,j)-k*lambda1)/(2*lambda2*omega(i,j)+2*gamma);
        if(temp>0&&temp<lt)
            x(2)=temp;
        elseif(temp<=0)
            x(2)=0;
        else%>=lt
            x(2)=lt;
        end
        result(2)=(lambda2*omega(i,j)+gamma)*x(2)^2-(2*lambda2*pI_x(i,j)*omega(i,j)+2*gamma*pL_x(i,j)-k*lambda1)*x(2)+(lambda2*omega(i,j)*pI_x(i,j)^2+gamma*pL_x(i,j)^2);
        
        %for -lt<=x<=0
        temp=(2*lambda2*omega(i,j)*pI_x(i,j)+2*gamma*pL_x(i,j)+k*lambda1)/(2*lambda2*omega(i,j)+2*gamma);
        if(temp>-lt&&temp<0)
            x(3)=temp;
        elseif(temp>=0)
            x(3)=0;
        else%<=-lt
            x(3)=-lt;
        end
        result(3)=(lambda2*omega(i,j)+gamma)*x(3)^2-(2*lambda2*pI_x(i,j)*omega(i,j)+2*gamma*pL_x(i,j)+k*lambda1)*x(3)+(lambda2*omega(i,j)*pI_x(i,j)^2+gamma*pL_x(i,j)^2);
        
        x_min=min(result);
        for k=1:3
            if(x_min == result(k))
                psi_x(i,j)=x(k);
                break;
            end
        end
        
        
        
        
        %for abs(x)>=lt
        temp=(pI_y(i,j)*lambda2*omega(i,j)+gamma*pL_y(i,j))/(lambda2*omega(i,j)+gamma+lambda1*a);
        if(abs(temp)>lt)
            x(1)=temp;
        elseif(temp>0)
            x(1)=lt;
        else
            x(1)=-lt;
        end
        result(1)=(a*lambda1+lambda2*omega(i,j)+gamma)*x(1)^2-2*(lambda2*pI_y(i,j)*omega(i,j)+gamma*pL_y(i,j))*x(1)+(b*lambda1+lambda2*omega(i,j)*pI_y(i,j)^2+gamma*pL_y(i,j)^2);
        
        %for 0<=x<=lt
        temp=(2*lambda2*omega(i,j)*pI_y(i,j)+2*gamma*pL_y(i,j)-k*lambda1)/(2*lambda2*omega(i,j)+2*gamma);
        if(temp>0&&temp<lt)
            x(2)=temp;
        elseif(temp<=0)
            x(2)=0;
        else%>=lt
            x(2)=lt;
        end
        result(2)=(lambda2*omega(i,j)+gamma)*x(2)^2-(2*lambda2*pI_y(i,j)*omega(i,j)+2*gamma*pL_y(i,j)-k*lambda1)*x(2)+(lambda2*omega(i,j)*pI_y(i,j)^2+gamma*pL_y(i,j)^2);
        
        %for -lt<=x<=0
        temp=(2*lambda2*omega(i,j)*pI_y(i,j)+2*gamma*pL_y(i,j)+k*lambda1)/(2*lambda2*omega(i,j)+2*gamma);
        if(temp>-lt&&temp<0)
            x(3)=temp;
        elseif(temp>=0)
            x(3)=0;
        else%<=-lt
            x(3)=-lt;
        end
        result(3)=(lambda2*omega(i,j)+gamma)*x(3)^2-(2*lambda2*pI_y(i,j)*omega(i,j)+2*gamma*pL_y(i,j)+k*lambda1)*x(3)+(lambda2*omega(i,j)*pI_y(i,j)^2+gamma*pL_y(i,j)^2);
        
        x_min=min(result);
        for k=1:3
            if(x_min == result(k))
                psi_y(i,j)=x(k);
                break;
            end
        end
    end
end


%function end
end