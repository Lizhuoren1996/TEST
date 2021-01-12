%==========================================
% example11_1
% 利用行列式比估计模型的阶次
% 见《过程辨识》，方崇智，清华大学出版社，P337，例13.2
%
close all;   clear;   clc
%% ==========产生M序列作为输入===============
x=[0 1 0 1 1 0 1 1 1]; %initial value
n=1003;      % n为脉冲数目
M=[];          % 存放M序列
for i=1:n
    temp=xor(x(4),x(9));
    M(i)=x(9);
    for j=9:-1:2
        x(j)=x(j-1);
    end
    x(1)=temp;
end
%% 产生带高斯白噪声的系统输出
v=randn(1,1003);
z=[];   z(1)=-1;   z(2)=0;
L=1000;
for i=3:L+3
    z(i)=1.630*z(i-1)-0.638*z(i-2)+0.0004*M(i-1)-0.0024*M(i-2)+v(i);
end
%% 计算行列式比
% n=1
for i=1:L
    H1(i,1)=z(i);
    H1(i,2)=M(i);
end
A=H1'*H1/L;
% n=2
for i=1:L
    H2(i,1)=z(i+1);
    H2(i,2)=z(i);
    H2(i,3)=M(i+1);
    H2(i,4)=M(i);
end
B=H2'*H2/L;
%n=3
for i=1:L
    H3(i,1)=z(i+2);
    H3(i,2)=z(i+1);
    H3(i,3)=z(i);
    H3(i,4)=M(i+2);
    H3(i,5)=M(i+1);
    H3(i,6)=M(i);
end
C=H3'*H3/L;
%n=4
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
D=H4'*H4/L;
DR(1)=det(A)/det(B);
DR(2)=det(B)/det(C);
DR(3)=det(C)/det(D);
DR
%% 画图
stem(1:3,DR);  title('利用行列式比估计模型阶次')
xlabel('阶次');  ylabel('行列式比')