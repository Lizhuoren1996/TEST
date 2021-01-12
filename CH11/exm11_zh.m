%例14.6
%根据不同准则，如输出预测误差、AIC准则等选择最优模型阶次
%Discrete-time IDPOLY model:A(q)y(t)=B(q)u(t)+e(t)
%A(q)=1-1.5q^-1+0.7q^-2
%B(q)=q^-1+0.5q^-2
clear;
clc;
Ts=0.001;
A=[1 -0.78 0.25];
B=[0 0.78 0.24];

NoiseSigma=0.2;
dsysm=idpoly(A,B,1,1,1,NoiseSigma,Ts);%Ts=1
e=NoiseSigma*randn(310,1);
de=iddata([],e,Ts);

u=idinput([31,1,10],'prbs',[0,1],[-1,1]);
du=iddata([],u,Ts);
du.intersample='zoh';

z_ideal=sim(dsysm,[du]);
z_noise=sim(dsysm,[du de]);

figure(1);subplot(2,1,1);
plot(0:310-1,z_ideal.y);
axis([0 310-1 1.2*min(min(z_ideal.y,z_noise.y)) 1.2*max(max(z_ideal.y,z_noise.y))]);
title('ideal output data');

subplot(2,1,2);plot(0:310-1,z_noise.y);
axis([0 310-1 1.2*min(min(z_ideal.y,z_noise.y)) 1.2*max(max(z_ideal.y,z_noise.y))]);
title('output data with Gaussian white noise');

data_noise=[z_noise du];
% data_noise=[z_ideal du];
V=arxstruc(data_noise(32:62),data_noise(63:93),struc(1:4,1:4,1:4));
nn=selstruc(V,'aic');%best fit to validation data
dsysm_e=arx(data_noise,nn);
disp('-------------Ture system model----------------:');dsysm
disp('------------Esimated system model------------:');dsysm_e

