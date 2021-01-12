%% 线性分析系统，直接求过渡时间和截止频率
%给系统参数的话用这个建立传递函数
num=[1];
den=[1 1]; %一阶
sys=tf(num,den); %sys是形成的一阶系统的传递函数
% %给模型时 ，直接用下面的命令求一个传递函数，扫频信号求截止频率的方法不用了，直接在图上取，老师可能给模型来辨识
% mdl='veh1_4_1_line';
% sys = linearize(mdl);
%% 从图上获取，画step图和bode图，step图中可以settingtime得到，伯德图自己找1，-3db
figure(1)
subplot 121; step(sys); grid on ;%grid on函数是打开网格
subplot 122; bode(sys); grid on ;

%%时域分析：获取阶跃响应的过渡时间
tmp = stepinfo(sys);
Ts=tmp.SettlingTime %%step图中可以settingtime得到的就是我们要的过渡时间

%%从图上取-3dB
[mag,ph,w]=bode(sys); %依次返回幅频、相频、角频率
mag = 20*log10(squeeze(mag)); %dB  也就是bode中magnitude=-3db时对应的frequency，单位是rad/s，就是我们要的截止频率
%%幅频特性的数据mag是普通意义的放大倍数，
%%而Bode图的纵轴用的是分贝值，需要按照20倍log律进行换算。
%%squeeze就是去除维度为1的
w0=spline(mag,w,mag(1)-3) % rad/s mag(1)就是M(0),是起始的地方，用mag和w去做三次样条插值，来求解m0-3db处对应的频率，就是截止频率。或者用find

%计算M序列
fM=w0/2/pi; %先根据截止角频率计算截止频率
delta=0.3/fM  %确定采样周期，取值要小于d=0.3/fM
delta=1; %根据上面的值，自己手动给采样周期取值
Np=[1/(fM*delta),1.2*Ts/delta,1.5*Ts/delta]   %%确定M序列的长度，这写了3中取值方式，可以只选择一种
M_Np=max(round(max(Np)),7)  %因为M序列周期的长度为7，15,31等这些数，然后对应确定寄存器个数
M_T=M_Np*delta  %m序列的周期,必须大于TS，这个确认一下
M_d=delta; %M序列的采样周期
if M_T>Ts
    disp('M序列周期大于原始系统')
end
simTime=11*M_T  %%M序列的周期xM序列的周期长度得到总的时间，这个要用来更改simulink模型中的stop Time
%% 运行系统模型
sim('mysys.slx')  %%调用产生M序列的simulink模型，并运行

%% 利用建立的系统模型的输入输出进行系统辨识
Q=iddata(myout,myin,M_d); 
figure(2)
plot(Q); %画出封装的输入输出数据
% ident  %打开系统辨识工具箱：
% 将在GUI中的操作复制下来，写在脚本文中
% 去均值 ，去第一个周期，划分辨识和检验数据
dataStart=M_T/M_d; %就是一个M序列周期的长度，这样去除这一个长度，就是去除了第一个周期的影响
Qe = Q([dataStart:end]); %根据影响去掉第一个周期
Qd = detrend(Qe);  %去趋势项
Qde = Qd([1:end/2]); %%前一半数据用来测试，用来进行辨识的数据
Qdv = Qd([end/2+1:end]);  %后一半数据用来验证，用来进行模型验证的数据
figure(3)
plot(Q,Qd,Qde,Qdv);
%% ident
NN = struc(1:10,1:10,1:10); %阶次选择范围
Loss_fun = arxstruc(Qde,Qdv,NN);  %损失函数
order = selstruc(Loss_fun);   %辨识系统阶次，手动选择，怎样算合适？
% order = selstruc(Loss_fun,'aic')
% order_aic = selstruc(Loss_fun,0)
Model = arx(Qde,order) % AR模型
%% 提取模型参数
Model_tf_d=tf(Model) %离散模型
% Model_tf_c=d2c(Model_tf_d) %连续模型
Model_tf_c=d2c(Model_tf_d,'tustin')
num1=cell2mat(Model_tf_c.num)
den1=cell2mat(Model_tf_c.den)
sim('myverify.slx')
figure(4)
compare(Qdv,Model); %预测输出与实际输出比较
figure(5)
resid(Model,Qde); 
