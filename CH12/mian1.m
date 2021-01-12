%% 系统参数
% num=[1];
% den=[1 1]; %一阶
sys= tf(num,den);

%% 设置起止频率
ts=0.001;   %%采样间隔，单位s
Tend=40;   %%仿真时间和扫频结束时间，单位s， 这个也要调节
Fstart=0;  %%扫频开始频率 S
Fend=0.16;  %% 扫频结束频率 Hz  ，这个也要调节
fmax=0.151;  %% Hz 截止频率 ，调节使其在两条线之间
w1=fmax*2*pi;  %%截止（角）频率 rad/s，我们要的是这个值
sim('test_sys_characteristics.slx');  %% 调用simulink模型，并运行
% ltiview(sys);  % 打开LTI窗口进行系统特性分析,选择plot类型为step 和bode来分析
figure(1)
subplot(1,2,1); 
step(sys); 
grid on ;
subplot(1,2,2); 
bode(sys); 
grid on ;
%% 时域分析
tmp=stepinfo(sys);
Ts = tmp.SettlingTime%%step图中可以settingtime得到的就是我们要的过渡时间

%% 从图上取-3dB
[mag,ph,w]=bode(sys);   %依次返回幅频、相频、角频率
mag=20*log10(squeeze(mag)); %dB  也就是bode中magnitude=-3db时对应的frequency，单位是rad/s，就是我们要的截止频率
w0=spline(mag,w,mag(1)-3);  % rad/s mag(1)就是M(0),是起始的地方，用mag和w去做三次样条插值，来求解m0-3db处对应的频率，就是截止频率。或者用find

%% 计算M序列参数
fM=w0/2/pi          %先根据截止角频率计算截止频率
delta=0.3/fM        %确定采样周期,取值要小于d=0.3/fM
%%
delta = 1;     %根据上面的值，手动取值
Np=[1/(fM*delta),1.2*Ts/delta,1.5*Ts/delta]    %确定M序列的长度
%%
M_Np=max(round(max(Np)),7);            %至少是7，M序列至少3个寄存器，对应周期为7(2^N-1)
M_T=M_Np*delta
M_d=delta;
if M_T>Ts
    disp('M序列周期大于原始系统')
end
simTime=7*M_T
%%
sim('mysys1.slx')
%% 利用建立的系统模型的输入输出进行系统辨识
% Q=iddata(myout,myin,M_d);
% figure(2)
% plot(Q);
% ident
% 
% Qe=Q([1:50])
% Qed = detrend(Qe)
%%
Q=iddata(myout,myin,M_d)
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
order = selstruc(Loss_fun);

Model=arx(Qde,order)
%% 提取模型参数
Model_tf_d=tf(Model) %离散模型
Model_tf_c=d2c(Model_tf_d) %连续模型
% Model_tf_c=d2c(Model_tf_d,'tustin')
num1=cell2mat(Model_tf_c.num)
den1=cell2mat(Model_tf_c.den)
sim('myverify1.slx')
figure(4)
compare(Qdv,Model);%预测输出与实际输比较
figure(5)
resid(Model,Qde); %模型预测误差及相关分析







