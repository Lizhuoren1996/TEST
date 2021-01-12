%% 系统参数
num=[1];
den=[1 1]; %一阶
sys=tf(num,den); %sys是形成的一阶系统的传递函数
%% 设置起止频率
ts=0.001;   %%采样间隔，单位s
Tend=40;   %%仿真时间和扫频结束时间，单位s， 这个也要调节
Fstart=0;  %%扫频开始频率 S
Fend=0.16;  %% 扫频结束频率 Hz  ，这个也要调节
fmax=0.151;  %% Hz 截止频率 ，调节使其在两条线之间
w1=fmax*2*pi;  %%截止（角）频率 rad/s，我们要的是这个值
sim('test_test_sys_characteristics.slx');  %% 调用simulink模型，并运行
% ltiview(sys);  % 打开LTI窗口进行系统特性分析,选择plot类型为step 和bode来分析
%% 从图上获取，画step图和bode图，step图中可以settingtime得到，伯德图自己找1，-3db
figure(1)
subplot 211; step(sys); grid on ;%grid on函数是打开网格
subplot 212; bode(sys); grid on ;

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
% sim('test_1');

%计算M序列
fM=w0/2/pi; %先根据截止角频率计算截止频率
delta=0.3/fM  %确定采样周期，取值要小于d=0.3/fM
delta=1; %根据上面的值，自己手动给采样周期取值
Np=[1/(fM*delta),1.2*Ts/delta,1.5*Ts/delta]   %%确定M序列的长度，这写了3中取值方式，可以只选择一种
M_Np=max(round(max(Np)),7)  %至少是7，M序列至少3个寄存器，对应一个M序列周期的长度为7；现在周期长度是15，对应4个移位寄存器,为什么和15之间取最值
M_T=M_Np*delta  %总的m序列的周期
M_d=delta; %M序列的采样周期
if M_T>Ts
    disp('M序列周期大于原始系统')
end
simTime=7*M_T  %%M序列的周期xM序列的周期长度得到总的时间，这个要用来更改simulink模型中的stop Time
%%
sim('test_mysys.slx')  %%调用产生M序列的simulink模型，并运行
%% 利用建立的系统模型的输入输出进行系统辨识
Q=iddata(myout,myin,M_d); %创建包含时域输出信号myout和输入信号myin的iddata对象。M_d指定实验数据的采样时间。
%使用iddata对象封装要标识的系统的输入和输出测量数据。系统辨识函数使用这些测量值来估计模型。模型验证功能使用输入测量值为仿真提供输入，
%使用输出测量值比较估计的模型响应与原始数据的吻合程度。
figure(2)
plot(Q); %画出封装的输入输出数据
% ident  %打开系统辨识工具箱：
% 将在GUI中的操作复制下来，写在脚本文中
% 去均值 ，去第一个周期，划分辨识和检验数据
dataStart=M_T/M_d; %就是一个M序列周期的长度，这样去除这一个长度，就是去除了第一个周期的影响
Qe = Q([dataStart:end]); %根据影响去掉第一个周期
Qd = detrend(Qe);  %去趋势项
Qde = Qd([1:end/2]); %%前一半数据用来测试
Qdv = Qd([end/2+1:end]);  %后一半数据用来验证
figure(3)
plot(Q,Qd,Qde,Qdv);
%% ident
NN = struc(1:10,1:10,1:10);
Loss_fun = arxstruc(Qde,Qdv,NN);
order = selstruc(Loss_fun);
% order = selstruc(Loss_fun,'aic')
% order_aic = selstruc(Loss_fun,0)
Model = arx(Qde,order) % AR模型
sim('test_myverify.slx')
figure(4)
compare(Qdv,Model); %预测输出与实际输比较
figure(5)
resid(Model,Qde); 
