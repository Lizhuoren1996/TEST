%%
simTime = dt*15*6;
dt = 0.1; simTime = dt*15*6;

%% step2 连续传递函数离散化
clc; clear;
num=10;  den=[1 3 10]; 
csys = tf(num,den); 
Ts=0.1;
dsys= c2d(csys,Ts)
step(csys,dsys)


%%
dnum=cell2mat(dsys.Numerator);
dden=cell2mat(dsys.Denominator);
step(tf(num,den),tf(dnum,dden,Ts))

%%
open_system('c2dModel')
%% step3 辨识系统
clc; clear;
m_est=idss(-1,1,1,0,'Ts',1);
dt=0.1;
simTime=dt*15*7;
open_system('estModel')
%%
sim('estModel');
dat = iddata(y,u,dt);
plot(dat)
%%
ident






