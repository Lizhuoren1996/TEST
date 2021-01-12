%%  最小二乘一次完成法
%------------------------------------------------
% 例1：flag=1  二阶系统
% z(k)-1.5z(k-1)+0.7z(k-2)=u(k-1)+0.5u(k-2)+v(k)
%------------------------------------------------
% 例1：flag=2  实际压力系统
% PV^(alf)=(beta)  --->logP=-(alf)logV+log(beta)
%------------------------------------------------
close all; clc;  clear;
flag = 1;

[u,z]=getData(flag);                               % 获取输入输出数据对
[HL,ZL]=createSampleMatrix(u,z,flag);  % 构造样本矩阵
c=LS(HL,ZL);                                            % 最小二乘一次完成法
showResult(c,flag);                                 % 显示辨识结果

%%   子程序
function y=LS(HL,ZL)
%% 最小二乘一次完成法
c1=HL'*HL; 
c2=inv(c1); 
c3=HL'*ZL; c=c2*c3; 
y=c;
end
function [in,out]=getData(flag)
%% 产生输入输出数据
switch flag
    case 1
        u=[-1,1,-1,1,1,1,1,-1,-1,-1,1,-1,-1,1,1]; % 输入信号为一个周期的M序列
        z=zeros(1,16); % 定义输出观测值的长度
        for k=3:16 
            z(k)=1.5*z(k-1)-0.7*z(k-2)+u(k-1)+0.5*u(k-2); %用理想输出值作为观测值
        end
        subplot(2,1,1) ;   stem(u); 
        subplot(2,1,2) ;  plot(1:16,z) ;hold on;    stem(z);
    case 2
        u=[54.3,61.8,72.4,88.7,118.6,194.0]';    
        z=[61.2,49.5,37.6,28.4,19.2,10.1]';         
end     
in=u;
out=z;
end
function [HL,ZL]=createSampleMatrix(u,z,flag)
%% 建立样本矩阵和观测矩阵
switch flag
    case 1
        HL=[-z(2) -z(1) u(2) u(1);
            -z(3) -z(2) u(3) u(2);
            -z(4) -z(3) u(4) u(3);
            -z(5) -z(4) u(5) u(4);
            -z(6) -z(5) u(6) u(5);
            -z(7) -z(6) u(7) u(6);
            -z(8) -z(7) u(8) u(7);
            -z(9) -z(8) u(9) u(8);
            -z(10) -z(9) u(10) u(9);
            -z(11) -z(10) u(11) u(10);
            -z(12) -z(11) u(12) u(11);
            -z(13) -z(12) u(13) u(12);
            -z(14) -z(13) u(14) u(13);
            -z(15) -z(14) u(15) u(14)];  % 给样本矩阵HL赋值

        ZL=[z(3);z(4);z(5);z(6);z(7);z(8);z(9);z(10);z(11);z(12);z(13);z(14);z(15);z(16)]; % 给样本矩阵zL赋值
    case 2
        ZL=log(z);                       % 给ZL赋值
        HL=[-log(u(1)),1;
            -log(u(2)),1;
            -log(u(3)),1;
            -log(u(4)),1;
            -log(u(5)),1;
            -log(u(6)),1];               % 给HL赋值
end
end
function showResult(c,flag)
%% 显示结果 
switch flag
    case 1
        str=sprintf('a1=%.4f;a2=%.4f;b1=%.4f;b2=%.4f',c(1),c(2),c(3),c(4));
        disp(str);
        %  a1=c(1), a2=c(2), b1=c(3), b2=c(4) %从 中分离出并显示a1 、a2、 b1、 b2
    case 2
        str=sprintf('alpha=%.4f;beta=%.4f',c(1),exp(c(2)));
        disp(str);
       %  alpha=c(1)           % 为c4的第1个元素
       %  beta=exp(c(2))    % 为以自然数为底的c4的第2个元素的指数
end
end