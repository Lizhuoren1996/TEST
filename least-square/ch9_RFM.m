function ch5_RFM()
% 限定记忆最小二乘算法 
% 限定记忆最小二乘算法：时变系统
% y(k)+a(k)y(k-1)=b(k)u(k-1)+e(k)
% 0<k<300 a(k)=0.8,b(k)=0.5
% k>300 a(k)=0.6,b(k)=0.3
% v(k)为零均值，方差为0.1的高斯白噪声
%======================================== 
clear ;clc ; clf ;% close all;

[u,z,v]=getInOut();
% L=80; %记忆长度 
L=80;Theta80=RFM(u,z,v,L);
L=60;Theta60=RFM(u,z,v,L);
L=40;Theta40=RFM(u,z,v,L);

figure(1);
size_tk=max([length(Theta80(1,:)),length(Theta60(1,:)),length(Theta40(1,:))]);
for i=2:30:900
    hold on;axis([0,1000,0.2 0.9]);
    plot([0 300 300 size_tk],[0.8 0.8 0.6 0.6],'--k');
    plot([0 300 300 size_tk],[0.5 0.5 0.3 0.3],'--k');
    % title(string);
    plot(Theta80(:,1:i)','r','linewidth',2);
    plot(Theta60(:,1:i)','b','linewidth',2);
    plot(Theta40(:,1:i)','m','linewidth',2);
    
    pause(0.2);
    hold off
end

% ------------ 子程序---------------------------------------------------
function y=RFM(u,z,v,L)
P_a=100*eye(2);     % 直接给出初始状态P0，即一个充分大的实数单位矩阵
Theta_a=[3;3];        % 被辨识参数的初始值
Theta_Store=zeros(2,1000);    % 参数的估计值，存放中间过程估值 
e=zeros(2,1000);    % 相对误差的初始值及大小
%==========限定记忆最小二乘算法===============
for i=2:L+1                                           % 前L个数据的辨识
h=[-z(i-1);u(i-1)];                                  % 构造矩阵h(k)
K=P_a*h*inv(h'*P_a*h+1);                     % 求出K的值
Theta_a1=Theta_a+K*(z(i)-h'*Theta_a); % 求被辨识参数
Theta_Store(:,i-1)=Theta_a1;                 % 把辨识参数列向量加入辨识参数矩阵的最后一列
e(:,i-1)=(Theta_a1-Theta_a)./Theta_a;    % 把当前相对变化的列向量加入误差矩阵的最后一列
Theta_a=Theta_a1;                                % 新获得的参数作为下一次递推的旧参数
P_a=(eye(2)-K*h')*P_a;                           % 求出p(k)的值给下次用
end 
for k=2:920 %利用限定记忆法对后面的数据进行辨识
%  -------先进一个观测数据-------
hL=[-z(k+L-1);u(k+L-1)];                                    % 构造矩阵h(k+L)
K_b=P_a*hL*inv(1+hL'*P_a*hL);                          % 求出K的值
Theta_b=Theta_a+K_b*(z(k+L)-hL'*Theta_a);      % 求被辨识参数
P_b=(eye(2)-K_b*hL')*P_a; %求出p(k)的值
%-------再出一个旧的观测数据-------
hk=[-z(k-1);u(k-1)];                                            % 构造矩阵h(k)
K_a=P_b*hk*inv(1-hk'*P_b*hk);                          % 求出K的值
Theta_a1=Theta_b-K_a*(z(k)-hk'*Theta_b);        % 求被辨识参数
Theta_Store(:,k+L-1)=Theta_a1;                         % 把辨识参数列向量加入辨识参数矩阵的最后一列
e(:,k+L-1)=(Theta_a1-Theta_a)./Theta_a;            % 把当前相对变化的列向量加入误差矩阵的最后一列
Theta_a=Theta_a1;                                            % 新获得的参数作为下一次递推的旧参数
P_a=(eye(2)+K_a*hk')*P_b;                                % 求出p(k)的值给下次用
end 
y=Theta_Store;
% 
% %========================输出结果及作图=========================== 
% disp('参数 ak bk 的估计值为：') 
% Theta_a %显示被辨识参数的辨识结果
% i=1:1000; 
% %画出被辨识参数的各次辨识结果
% figure(2) 
% plot(i,Theta_Store(1,:),i,Theta_Store(2,:)) 
% axis([0 1000 0 1]);
% grid on
% title('辨识参数过渡过程') 
% %画出各次辨识结果的收敛情况
% figure(3) 
% plot(i,e(1,:),i,e(2,:)) 
% axis([0 1000 -0.1 0.1]);
% title('相对误差变化过程')


function [u,z,v]=getInOut()
%==========产生 M 序列===============
u=[-1,1,-1,1,1,1,1,-1,-1,-1,1,-1,-1,1,1]*10;      %M 序列初始值 
n=1001; %n 为脉冲数目 
%===生成四级移位寄存器产生的 M 序列作为输入===
for k=1:n
if mod(k,15)~=0               
        u(k)=u(mod(k,15));
    else
        u(k)=u(15);
end
end
%以径线形式显示出输入信号
% figure(1)
% stem(u);
% axis([0 15 -10 10]);
% title('M序列输入信号')
% grid on
%===========产生均值为 0，方差为 0.1 的高斯白噪声========= 
v=randn(1,1001);     
    a=0;                           %噪声均值
    b=0.1;                         %噪声方差
    v=v/std(v);
    v=v-mean(v);
    v=a+b*v;
z=[]; 
z(1)=0; %取z的初始值为零
%==========给出理想的辨识输出采样信号===============
for i=2:1001 %循环变量从2到1001
    if i<300
        z(i)=-0.8*z(i-1)+0.5*u(i-1)+v(i); %当i<300时的理想辨识输出采样信号
    else
        z(i)=-0.6*z(i-1)+0.3*u(i-1)+v(i); %当i>=300时的理想辨识输出采样信号
    end
end 
% figure;
% subplot 211;stem(u);  axis([0 15 -10 10]);title('M序列输入信号');
% subplot 212;plot(z); axis([0 1000 -20 20]);title('输出观测信号');

