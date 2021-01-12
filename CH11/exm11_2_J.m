%---------------------------------
%example11_2
%利用残差的方差估计模型的阶次
%方崇智，过程辨识，清华大学出版社；P345，例13.4
%===================================
close all;   clear;   clc
%% ==========产生M序列作为输入===============
x=[0 1 0 1 1 0 1 1 1]; %initial value
n=1003; %n为脉冲数目
M=[]; %存放M序列
for i=1:n
temp=xor(x(4),x(9));
M(i)=x(9);
for j=9:-1:2
x(j)=x(j-1);
end
x(1)=temp;
end
%% 产生带高斯白噪声的系统输出
v=randn(1,1004);
z=[];
z(1)=-1;
z(2)=0;
L=1000;
for i=3:L+4
z(i)=1.5*z(i-1)-0.7*z(i-2)+M(i-1)+0.5*M(i-2)+v(i);
end
%% 计算残差
theta=zeros(8,4);
% 模型阶次n=1
for i=1:L
H1(i,1)=z(i);;
H1(i,2)=M(i);
end
estimate=inv(H1'*H1)*H1'*z(2:1001)';
theta(1:2,1)=estimate;
e=z(2:1001)'-H1*estimate;
V1=e'*e/L;
% 模型阶次n=2
for i=1:L
H2(i,1)=z(i+1);;
H2(i,2)=z(i);
H2(i,3)=M(i+1);
H2(i,4)=M(i);
end
estimate=inv(H2'*H2)*H2'*z(3:1002)';
theta(1:4,2)=estimate;
e=z(3:1002)'-H2*estimate;
V2=e'*e/L;
% 模型阶次n=3
for i=1:L
H3(i,1)=z(i+2);
H3(i,2)=z(i+1);
H3(i,3)=z(i);
H3(i,4)=M(i+2);
H3(i,5)=M(i+1);
H3(i,6)=M(i);
end
estimate=inv(H3'*H3)*H3'*z(4:1003)';
theta(1:6,3)=estimate;
e=z(4:1003)'-H3*estimate;
V3=e'*e/L;
% 模型阶次n=4
for i=1:L
H4(i,1)=z(i+3);
H4(i,2)=z(i+2);
H4(i,3)=z(i+1);
H4(i,4)=z(i);
H4(i,5)=M(i+3);
H4(i,6)=M(i+2);
H4(i,7)=M(i+1);
H4(i,8)=M(i);
end
estimate=inv(H4'*H4)*H4'*z(5:1004)'
theta(1:8,4)=estimate;
e=z(5:1004)'-H4*estimate;
V4=e'*e/L;
theta
[V1 V2 V3 V4]
%% 画图
plot(1:4,[V1 V2 V3 V4])
title('利用残差的方差估计模型的阶次')
xlabel('阶次');  ylabel('残差方差')