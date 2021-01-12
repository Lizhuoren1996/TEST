%% 1911055李拙人
% clc; clear;
% num=[1]; den=[1 1];              % 一阶系统
% den=[1 0.6 1];
% num=[0.04798 0.0464]; den=[1 -1.81 0.9048];
% noiseAmp=0.1;
% sys = tf(num,den);
sys=linsys1;
%% 时域分析
tmp = stepinfo(sys);
Ts=tmp.SettlingTime
%% 取-3dB
[mag,ph,w]=bode(sys);   %依次返回幅频、相频、角频率
mag = 20*log10(squeeze(mag));    % dB
% plot(mag,w)
w0=spline(mag,w,mag(1)-3)    % rad/s 

%% 计算M/IM序列参数
fM=w0/2/pi     % Hz
delta=0.3/fM 
delta = 30;     %根据上面的值，手动取值
Np=[1/(fM*delta),1.2*Ts/delta,1.5*Ts/delta]    %确定M序列的长度

M_Np=max(round(max(Np)),7); 
M_T=M_Np*delta;
M_Np=M_Np*2;
M_T=M_T*2;
M_d=delta;
if M_T>Ts
    disp('M序列周期大于原始系统')
end
simTime=11*M_T
%%
sim('mysysIM.slx');

%%
Q=iddata(myout,myin,M_d);
figure(2)
plot(Q);%画出封装的输入输出数据
dataStart = M_T/M_d;    
Qe = Q([dataStart:end]);%       去第一个周期
Qd=detrend(Qe);     %去趋势项
% plot(Qe,Qd);
Qde=Qd([1:end/2]);  %前一半数据用来测试
Qdv=Qd([end/2+1:end]);  %后一半数据用来验证
figure(3)
plot(Q,Qd,Qde,Qdv);
%% ident
NN=struc(1:10,1:10,1:10);
Loss_fun= arxstruc(Qde,Qdv,NN);
order =[4 4 1];

Model=arx(Qde,order)

figure(4)
compare(Qdv,Model);%预测输出与实际输比较
figure(5)
resid(Model,Qde); %模型预测误差及相关分析


Model_tf_d=tf(Model) %离散模型
Model_tf_c=d2c(Model_tf_d) %连续模型
% Model_tf_c=d2c(Model_tf_d,'tustin')

num=cell2mat(Model_tf_d.num)
den=cell2mat(Model_tf_d.den)
num1=cell2mat(Model_tf_c.num)
den1=cell2mat(Model_tf_c.den)
sim('myverify2.slx')


% plot(simVerifyOut.time,simVerifyOut.signals.values(:,1),simVerifyOut.time,simVerifyOut.signals.values(:,2));












