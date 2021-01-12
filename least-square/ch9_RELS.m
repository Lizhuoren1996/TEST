%RELS增广递推最小二乘

close all;%清除所有的图形窗口
clear;    %清除所有变量
clc       %清屏，命令窗口

%----------------生成M序列-------------------
L=60;%四位移位积存器产生的M序列的周期
y1=1;y2=1;y3=1;y4=0;%四个移位积存器的输出初始值
for i=1:L;
    x1=xor(y3,y4);%第一个移位积存器的输入信号
    x2=y1;%第二个移位积存器的输入信号
    x3=y2;%第三个移位积存器的输入信号
    x4=y3;%第四个移位积存器的输入信号
    y(i)=y4;%第四个移位积存器的输出信号，幅值"0"和"1"
    if y(i)>0.5,u(i)=-1;%M序列的值为"1"时,辨识的输入信号取“-1”
    else u(i)=1;%M序列的值为"0"时,辨识的输入信号取“1”
    end
    y1=x1;y2=x2;y3=x3;y4=x4;%为下一次的输入信号作准备
end
figure(1);%画第一个图形
subplot(2,1,1); %画第一个图形的第一个子图
stem(u),grid on%画出M序列输入信号
v=randn(1,60); %产生一组60个正态分布的随机噪声
subplot(2,1,2); %画第一个图形的第二个子图
plot(v),grid on;%画出随机噪声信号
R=corrcoef(u,v);%计算输入信号与随机噪声信号的相关系数
r=R(1,2);%取出互相关系数
u%显示输入型号
v%显示噪声型号

%----------------增广递推最小二乘RELS-------------------

z=zeros(7,60);zs=zeros(7,60);zm=zeros(7,60);zmd=zeros(7,60);%输出采样、不考虑噪声时系统输出、不考虑噪声时模型输出、模型输出矩阵的大小
z(2)=0;z(1)=0;zs(2)=0;zs(1)=0;zm(2)=0;zm(1)=0;zmd(2)=0;zmd(1)=0;%给输出采样、不考虑噪声时系统输出、不考虑噪声时模型输出、模型输出赋初值
%增广递推最小二乘辨识
c0=[0.001 0.001 0.001 0.001 0.001 0.001 0.001]';%直接给出被辨识参数的初始值,即一个充分小的实向量
p0=10^6*eye(7,7);%直接给出初始状态P0，即一个充分大的实数单位矩阵
E=5.0e-15;%取相对误差E
c=[c0,zeros(7,59)];%被辨识参数矩阵的初始值及大小
e=zeros(7,60);%相对误差的初始值及大小

for k=3:60; %开始求K
    %----计算系统输出---
    z(k)=1.5*z(k-1)-0.7*z(k-2)+u(k-1)+0.5*u(k-2)+v(k)-v(k-1)+0.2*v(k-2);%系统在M序列输入下的输出采样信号
    
    %----构造样本矩阵H---
    h1=[-z(k-1),-z(k-2),u(k-1),u(k-2),v(k),v(k-1),v(k-2)]';%为求K(k)作准备
    
    %----求增益矩阵K(k)---
    x=h1'*p0*h1+1; x1=inv(x); k1=p0*h1*x1; %K
    
    %----求被辨识参数theta(k)---
    d1=z(k)-h1'*c0; c1=c0+k1*d1;%辨识参数c
    zs(k)=1.5*z(k-1)-0.7*z(k-2)+u(k-1)+0.5*u(k-2);%系统在M序列的输入下不考虑扰动时的输出响应
    zm(k)=[-z(k-1),-z(k-2),u(k-1),u(k-2)]*[c1(1);c1(2);c1(3);c1(4)];%模型在M序列的输入下不考虑扰动时的的输出响应
    zmd(k)=h1'*c1;%模型在M序列的输入下的的输出响应
    
    %----计算误差---
    e1=c1-c0;
    e2=e1./c0; %求参数的相对变化
    e(:,k)=e2;
    c0=c1;%给下一次用
    c(:,k)=c1;%把辨识参数c 列向量加入辨识参数矩阵
    
    %----求矩阵P(k)---
    p1=p0-k1*k1'*[h1'*p0*h1+1];%find p(k)
    p0=p1;%给下次用
    
    %----判断终止条件---
    if e2<=E break;%若收敛情况满足要求，终止计算
    end%判断结束
end%循环结束
c, e, %显示被辨识参数及参数收敛情况
z,zmd %显示输出采样值、系统实际输出值、模型输出值


%分离变量
a1=c(1,:); a2=c(2,:); b1=c(3,:); b2=c(4,:);%分离出a1、 a2、 b1、 b2
d1=c(5,:); d2=c(6,:); d3=c(7,:); %分离出d1、 d2、 d3
ea1=e(1,:); ea2=e(2,:); eb1=e(3,:); eb2=e(4,:); %分离出a1、 a2、 b1、 b2的收敛情况
ed1=e(5,:); ed2=e(6,:); ed3=e(7,:); %分离出d1 、d2 、d3的收敛情况
figure(2);%画第二个图形
i=1:60;
plot(i,a1,'r',i,a2,'r:',i,b1,'b',i,b2,'b:',i,d1,'g',i,d2,'g:',i,d3,'g+')%画出各个被辨识参数
title('Parameter Identification with Recursive Least Squares Method')%标题
figure(3);%画出第三个图形
i=1:60;
plot(i,ea1,'r',i,ea2,'r:',i,eb1,'b',i,eb2,'b:',i,ed1,'g',i,ed2,'g:',i,ed2,'r+')%画出各个参数收敛情况
title('Identification Error')%标题
%response%响应
figure(4);%画出第四个图形
subplot(4,1,1); %画出第四个图形中的四个子图的第一个子图
i=1:60;
plot(i,zs(i),'r')%画出被辨识系统在没有噪声情况下的实际输出响应
subplot(4,1,2); %画出第四个图形中的四个子图的第二个子图
i=1:60;
plot(i,z(i),'g')%画出被辨识系统的采样输出响应
subplot(4,1,3); %画出第四个图形中的四个子图的第三个子图
i=1:60;
plot(i,zmd(i),'b')%画出模型含有噪声的输出响应
subplot(4,1,4); %画出第四个图形中的四个子图的第四个子图
i=1:60;
plot(i,zm(i),'b')%画出模型去除噪声后的输出响应
