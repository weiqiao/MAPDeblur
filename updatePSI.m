function [ psi_x,psi_y ] = updatePSI( lambda1,lambda2,omega,gamma,L,I )
%UPDATEPSI Summary of this function goes here
%   Detailed explanation goes here
diff_x=[1,-1];
diff_y=[1,-1]';
pI_x=conv2(I,diff_x,'same');
pI_y=conv2(I,diff_y,'same');
pL_x=conv2(L,diff_x,'same');
pL_y=conv2(L,diff_y,'same');
a=6.1*10^-4*255*255;
b=5.0;
k=2.7*255;
lt=(k-sqrt(k^2-4*a*b))/(2*a);

[row,col]=size(I);
psi_x=zeros(row,col);
psi_y=zeros(row,col);
%assume abs(x)>lt
for i=1:row
    for j=1:col
        %for x
        temp=(pI_x(i,j)*lambda2*omega(i,j)+gamma*pL_x(i,j))/(lambda2*omega(i,j)+gamma-lambda1*a);
        if(abs(temp)>lt)
            psi_x(i,j)=temp;
        else
            temp=(2*lambda2*omega(i,j)*pI_x(i,j)+2*gamma*pL_x(i,j)+k*lambda1)/(2*lambda2*omega(i,j)+2*gamma);
            if(temp>0&&temp<=lt)
                psi_x(i,j)=temp;
            else
                first=lambda1*(-k)*lt+lambda2*omega(i,j)*(lt-pI_x(i,j))^2+gamma*(lt-pL_x(i,j))^2;%lt取到
                temp=(2*lambda2*omega(i,j)*pI_x(i,j)+2*gamma*pL_x(i,j)-k*lambda1)/(2*lambda2*omega(i,j)+2*gamma);
                if(temp<=0&&temp>=-lt)
                    psi_x(i,j)=temp;
                else
                    second=lambda2*omega(i,j)*pI_x(i,j)^2+gamma*pL_x(i,j)^2;%0取到
                    third=lambda1*k*(-lt)+lambda2*omega(i,j)*(-lt-pI_x(i,j))^2+gamma*(-lt-pL_x(i,j))^2;%-lt取到
                    min_value=min([first,second,third]);
                    if(first == min_value)
                        psi_x(i,j)=lt;
                    elseif(second == min_value)
                        psi_x(i,j)=0;
                    else
                        psi_x(i,j)=-lt;
                    end
                end
            end
        end
        
        %for y
        temp=(pI_y(i,j)*lambda2*omega(i,j)+gamma*pL_y(i,j))/(lambda2*omega(i,j)+gamma-lambda1*a);
        if(abs(temp)>lt)
            psi_y(i,j)=temp;
        else
            temp=(2*lambda2*omega(i,j)*pI_y(i,j)+2*gamma*pL_y(i,j)+k*lambda1)/(2*lambda2*omega(i,j)+2*gamma);
            if(temp>0&&temp<=lt)
                psi_y(i,j)=temp;
            else
                first=lambda1*(-k)*lt+lambda2*omega(i,j)*(lt-pI_y(i,j))^2+gamma*(lt-pL_y(i,j))^2;%lt取到
                temp=(2*lambda2*omega(i,j)*pI_y(i,j)+2*gamma*pL_y(i,j)-k*lambda1)/(2*lambda2*omega(i,j)+2*gamma);
                if(temp<=0&&temp>=-lt)
                    psi_y(i,j)=temp;
                else
                    second=lambda2*omega(i,j)*pI_y(i,j)^2+gamma*pL_y(i,j)^2;%0取到
                    third=lambda1*k*(-lt)+lambda2*omega(i,j)*(-lt-pI_y(i,j))^2+gamma*(-lt-pL_y(i,j))^2;%-lt取到
                    min_value=min([first,second,third]);
                    if(first == min_value)
                        psi_y(i,j)=lt;
                    elseif(second == min_value)
                        psi_y(i,j)=0;
                    else
                        psi_y(i,j)=-lt;
                    end
                end
            end
        end
    end
end

%function end
end

