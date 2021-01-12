
num = [1];den = [1 1];
% num=[12];den=[0.24,3,1];

sys=tf(num,den);
% bode(sys);%图上获得截止频率
%% 二阶系统
% num=[12];
% den=[0.24,3,1];
% sys=tf(num,den);
% % bode(sys);
% ts=0.001;
% Tend=100;
% Fstart=0;
% Fend=0.08;
% fmax=0.055;
% w1=fmax*2*pi;
% sim('test_sys_characteristics.slx');
%%
ts=0.001;%采样间隔
Tend=40;%仿真时间和扫频
Fstart=0;%扫频开始频率
Fend=0.16;
fmax=0.151;
w1=fmax*2*pi;%截止频率
sim('test_sys_characteristics.slx');