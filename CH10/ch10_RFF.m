function f=ch9_RFF()
% 遗忘因子最小二乘递推算法：时变系统
% y(k)+a(k)y(k-1)=b(k)u(k-1)+e(k)
% 0<k<300 a(k)=0.8,b(k)=0.5
% k>300 a(k)=0.6,b(k)=0.3
% e(k)为零均值，方差为0.1的高斯白噪声

close all;
clear;
clc;

u=[-1,1,-1,1,1,1,1,-1,-1,-1,1,-1,-1,1,1]*10;  % 可调整信噪比
p0=1000^2*eye(2);
tol=1e-3;
it=1000;  %
eflag=1;  % 有噪声

r=1;     %遗忘因子
[theta1,tk_hist1]=RFF(u,1,p0,tol,it,eflag);
[theta099,tk_hist099]=RFF(u,0.99,p0,tol,it,eflag);
[theta09,tk_hist09]=RFF(u,0.9,p0,tol,it,eflag);

figure(1);
s1=size(tk_hist1);
s099=size(tk_hist099);
s09=size(tk_hist09);
size_tk=max([s1(2),s099(2),s09(2)]);
for i=2:10:size_tk
    hold on;
    plot([0 300 300 size_tk],[0.8 0.8 0.6 0.6],'--k');
    plot([0 300 300 size_tk],[0.5 0.5 0.3 0.3],'--k');
    % title(string);
    plot(tk_hist1(:,1:i)','r','linewidth',2);
    plot(tk_hist099(:,1:i)','b','linewidth',2);
    plot(tk_hist09(:,1:i)','m','linewidth',2);
    
    pause(0.2);
    hold off
end

% 遗忘因子最小二乘法
function [theta,tk_hist]=RFF(u,r,p0,tol,it,eflag)
% u为输入4级M序列
% r为遗忘因子
% p0为P(k)矩阵初始值
% tol待辨识参数的初值
% theta输出待辨识参数
% eflag为噪声控制：1=有噪声，0=无噪声
if eflag==1
    v=randn(1,10000);     
    a=0;                            % 噪声均值
    b=0.1;                         % 噪声方差
    v=v/std(v);
    v=v-mean(v);
    v=a+b*v;
    string=['均值为' num2str(a) '方差为' num2str(b) '白噪声且遗忘'...
        '因子r=' num2str(r) '时系统辨识过程'];
else
    v=zeros(1,10000);
    string=['无噪声，遗忘因子r=' num2str(r) '时系统辨识过程'];
end
y(1)=v(1);                            % y(1)和z(2)等于0，如果有噪声就等于噪声
ab1=[0.8 0.5]';                    % 模型参数用于构造hk
ab2=[0.6 0.3]';    
tk=tol*ones(2,1);              
pk=p0;
k=2;                                  % 迭代次数控制
tk_hist=tk;                         % 保存待辨识参数计算过程
while(k<it) 
    if mod(k,15)~=0           % k>15时M序列的取值
        u(k)=u(mod(k,15));
    else
        u(k)=u(15);
    end
    hk=[-y(k-1) u(k-1)]';
    if k<300
        y(k)=hk'*ab1+v(k);
    else
        y(k)=hk'*ab2+v(k);
    end
    kk=pk*hk/(hk'*pk*hk+r);    % PPT-式68
    pk=(eye(2)-kk*hk')*pk/r;   
    tk=tk+kk*(y(k)-hk'*tk);
    tk_hist=[tk_hist tk];             % 保存计算过程
    k=k+1;
end
theta=[tk_hist(:,300) tk_hist(:,end)];

